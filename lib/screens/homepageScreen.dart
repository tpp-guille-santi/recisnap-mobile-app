import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/informationScreen.dart';
import 'package:recyclingapp/screens/mapScreen.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../providers/instructionProvider.dart';
import '../utils/neuralNetworkConnector.dart';
import '../widgets/instructionContent.dart';
import 'loadingScreen.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController scrollController = ScrollController();
  final PanelController panelController = PanelController();

  late CameraController cameraController;
  late NeuralNetworkConnector cnnConnector;

  int index = 1;

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      InformationScreen(),
      LoadingScreen(),
      MapScreen(
        panelController: panelController,
        scrollController: scrollController,
      ),
    ];
    initialize();
  }

  void _onDestinationSelected(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void _onSwitchToMapScreen(BuildContext context) {
    setState(() {
      index = 2;
    });
    context.read<Instruction>().firstLoad = true;
    scrollController.jumpTo(0);
    panelController.animatePanelToSnapPoint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height,
        snapPoint: 0.25,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panelBuilder: () => instructionContent(
            scrollController, context, panelController, _onSwitchToMapScreen),
        scrollController: scrollController,
        body: Scaffold(
          body: screens[index],
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
            selectedIndex: index,
          ),
        ),
      ),
    );
  }

  Future<void> initialize() async {
    if (await Permission.camera.request().isDenied ||
        await Permission.locationWhenInUse.request().isDenied) {
      exit(0);
    }
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController.initialize();
    final customModel = await FirebaseModelDownloader.instance.getModel(
        "recisnap-nn",
        FirebaseModelDownloadType.localModelUpdateInBackground,
        FirebaseModelDownloadConditions(
          iosAllowsCellularAccess: true,
          iosAllowsBackgroundDownloading: true,
          androidChargingRequired: false,
          androidWifiRequired: false,
          androidDeviceIdleRequired: false,
        ));
    final downloadedModel = customModel.file;
    cnnConnector = NeuralNetworkConnector(downloadedModel);
    setState(() {
      screens = [
        InformationScreen(),
        CameraScreen(
          panelController: panelController,
          scrollController: scrollController,
          cameraController: cameraController,
          cnnConnector: cnnConnector,
        ),
        MapScreen(
          panelController: panelController,
          scrollController: scrollController,
        ),
      ];
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
