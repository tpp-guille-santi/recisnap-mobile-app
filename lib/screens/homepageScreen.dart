import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/materialsCatalogueScreen.dart';

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
    Container(),
    CameraScreen(
      controller: null,
      future: null,
    ),
    MaterialsCatalogue()
  ];

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
      _showFab = (index == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREEN_COLOR,
      body: screens.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Reciclaje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Catálogo',
          ),
        ],
        currentIndex: _index,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: Colors.black26,
        backgroundColor: DARK_GREEN_COLOR,
      ),
      floatingActionButton: Visibility(
        visible: _showFab,
        child: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              //Mandar a server
              //Pasar a resultado
              print("Test");
              print("Ready: $_showFab");
              print(image.path);
              final result = await Navigator.pushNamed(
                context,
                '/results',
                arguments: {'test': 't'},
              );

              print("Returns: $result");
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
    WidgetsFlutterBinding.ensureInitialized();
    try {
      // initialize cameras.
      var cameras = await availableCameras();
      _firstCamera = cameras.first;
      // initialize camera controllers.
      _controller = new CameraController(_firstCamera, ResolutionPreset.medium);
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
