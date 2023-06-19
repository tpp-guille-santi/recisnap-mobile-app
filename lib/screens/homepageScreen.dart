import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart' as location_package;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/entities/instruction.dart';
import 'package:recyclingapp/providers/instructionMarkdownProvider.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/informationScreen.dart';
import 'package:recyclingapp/screens/mapScreen.dart';
import 'package:recyclingapp/utils/markdownManager.dart';
import 'package:recyclingapp/utils/neuralNetworkConnector.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../providers/imageProvider.dart';
import '../widgets/instructionContent.dart';

class Homepage extends StatefulWidget {
  final PanelController _panelController = PanelController();

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late CameraController _controller;
  bool _showFab = true;
  late Future<void> _initializeControllerFuture;
  int _index = 1;
  List<Widget> screens = [
    InformationScreen(),
    CameraScreen(
      controller: null,
      future: null,
    ),
    // MaterialsCatalogue(),
    MapScreen(panelController: null)
  ];
  late NeuralNetworkConnector cnnConnector;
  MarkdownManager markdownManager = new MarkdownManager();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _index = index;
      _showFab = (index == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: widget._panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height,
        snapPoint: 0.25,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panelBuilder: (sc) =>
            instructionContent(sc, context, widget._panelController),
        body: Scaffold(
          body: Stack(
            children: [
              Opacity(
                opacity: 1,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                ),
              ),
              Opacity(
                  opacity: _isLoading ? 0.0 : 1.0,
                  child: screens.elementAt(_index)),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: const <NavigationDestination>[
              NavigationDestination(
                selectedIcon: Icon(Icons.school),
                icon: Icon(Icons.school_outlined),
                label: 'Reciclaje',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.camera_alt),
                icon: Icon(Icons.camera_alt_outlined),
                label: 'Camera',
              ),
              // NavigationDestination(
              //   selectedIcon: Icon(Icons.view_list),
              //   icon: Icon(Icons.view_list_outlined),
              //   label: 'Catálogo',
              // ),
              NavigationDestination(
                selectedIcon: Icon(Icons.map),
                icon: Icon(Icons.map_outlined),
                label: 'Mapa',
              ),
            ],
            onDestinationSelected: _onDestinationSelected,
            selectedIndex: _index,
          ),
          floatingActionButton: Visibility(
            visible: _showFab,
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  //Mandar a red
                  print("saque foto");
                  var material =
                      await cnnConnector.cataloguePicture(image.path);
                  print(material);
                  print("termine de clasificar");
                  //Obtener latitud y longitud
                  final location_package.Location location =
                      location_package.Location();
                  final locationData = await location.getLocation();
                  //Obtener el markdown del server.
                  Instruction instruction =
                      await markdownManager.getInstruction(material,
                          locationData.latitude, locationData.longitude);
                  setState(() {
                    _isLoading = false;
                  });
                  context
                      .read<InstructionMarkdown>()
                      .resetInstructionMarkdown();
                  context
                      .read<InstructionMarkdown>()
                      .setInstruction(instruction, true);
                  context
                      .read<InstructionMarkdown>()
                      .setInstructionMarkdown(instruction);
                  widget._panelController.animatePanelToSnapPoint();
                  context.read<ImagePath>().setImagePath(image.path);
                  //Mostrar el resultado al usuario
                  InstructionMarkdown provider = InstructionMarkdown();
                  provider.setInstructionMarkdown(instruction);
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initialize() async {
    if (await Permission.camera.request().isDenied) {
      exit(0);
    }
    if (await Permission.locationWhenInUse.request().isDenied) {
      exit(0);
    }
    var cameras = await availableCameras();
    _controller = new CameraController(cameras.first, ResolutionPreset.medium,
        enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    var customModel = await FirebaseModelDownloader.instance.getModel(
        "recisnap-nn",
        FirebaseModelDownloadType.localModelUpdateInBackground,
        FirebaseModelDownloadConditions(
          iosAllowsCellularAccess: true,
          iosAllowsBackgroundDownloading: true,
          androidChargingRequired: false,
          androidWifiRequired: false,
          androidDeviceIdleRequired: false,
        ));
    var downloadedModel = customModel.file;
    //var assetModel = await copyAssetToFile("assets/model.tflite", "my_model.tflite");
    var labelFile = await copyAssetToFile("assets/labels.txt", "my_labels.txt");
    this.cnnConnector = NeuralNetworkConnector(downloadedModel, labelFile);

    setState(() {
      screens[1] = CameraScreen(
          future: _initializeControllerFuture, controller: _controller);
      screens[2] = MapScreen(panelController: widget._panelController);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> copyAssetToFile(String asset, String path) async {
    var bytes = await rootBundle.load(asset);
    final buffer = bytes.buffer;
    final directory = await getApplicationDocumentsDirectory();
    return new File('${directory.path}/$path').writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }
}
