import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/informationScreen.dart';
import 'package:recyclingapp/screens/mapScreen.dart';
import 'package:recyclingapp/screens/materialsCatalogueScreen.dart';
import 'package:recyclingapp/utils/markdownManager.dart';
import 'package:recyclingapp/utils/neuralNetworkConnector.dart';
import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _firstCamera;
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
    MaterialsCatalogue(),
    MapScreen()
  ];
  NeuralNetworkConnector cnnConnector = NeuralNetworkConnector();
  MarkdownManager markdownManager = new MarkdownManager();

  @override
  void initState() {
    super.initState();
    _setupCamera();
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
            selectedIcon: Icon(Icons.view_list),
            icon: Icon(Icons.view_list_outlined),
            label: 'Catálogo',
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
      floatingActionButton: Visibility(
        visible: _showFab,
        child: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              //Mandar a server
              var response = await cnnConnector.cataloguePicture(image.path);
              var material = response['name'];
              var instructions =
                  await markdownManager.getInstructions(material);
              //Pasar a resultado
              final result = await Navigator.pushNamed(
                context,
                '/results',
                arguments: {
                  'instructions': instructions,
                  'cameraIndex': 1,
                  'catalogueIndex': 2
                },
              );
              print("Returns: $result");
              _onDestinationSelected(result as int);
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  Future<void> _setupCamera() async {
    if (await Permission.camera.request().isDenied) {
      exit(0);
    }
    if (await Permission.locationWhenInUse.request().isDenied) {
      exit(0);
    }
    WidgetsFlutterBinding.ensureInitialized();
    try {
      // initialize cameras.
      var cameras = await availableCameras();
      _firstCamera = cameras.first;
      // initialize camera controllers.
      _controller = new CameraController(_firstCamera, ResolutionPreset.medium, enableAudio: false);
      _initializeControllerFuture = _controller.initialize();
      setState(() {
        screens[1] = CameraScreen(
            future: _initializeControllerFuture, controller: _controller);
      });
    } on CameraException catch (_) {
      return;
    }
  }



  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
}
