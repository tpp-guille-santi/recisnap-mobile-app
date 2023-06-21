import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/informationScreen.dart';
import 'package:recyclingapp/screens/mapScreen.dart';
import 'package:recyclingapp/utils/neuralNetworkConnector.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/instructionContent.dart';

class Homepage extends StatefulWidget {
  final PanelController _panelController = PanelController();

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late CameraController cameraController;
  int _index = 0;
  List<Widget> screens = [
    InformationScreen(),
    InformationScreen(),
    InformationScreen(),
  ];
  late NeuralNetworkConnector cnnConnector;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _index = index;
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
          body: screens.elementAt(_index),
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
              NavigationDestination(
                selectedIcon: Icon(Icons.map),
                icon: Icon(Icons.map_outlined),
                label: 'Mapa',
              ),
            ],
            onDestinationSelected: _onDestinationSelected,
            selectedIndex: _index,
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
    cameraController = new CameraController(
        cameras.first, ResolutionPreset.medium,
        enableAudio: false);
    Future<void> cameraControllerFuture = cameraController.initialize();
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
          panelController: widget._panelController,
          cnnConnector: cnnConnector,
          cameraController: cameraController,
          cameraControllerFuture: cameraControllerFuture);
      screens[2] = MapScreen(panelController: widget._panelController);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
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
