import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:recyclingapp/screens/resultScreen.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  var _firstCamera;
  late CameraController _controller;
  bool _isReady = false;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCamera();
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
    } on CameraException catch (_) {
      // do something on error.
      return;
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) return new Container();
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            //Mandar a server
            //Pasar a resultado
            print("Test");
            print(image.path);
            final result = await Navigator.pushNamed(context, '/results',
                arguments: {'test': 't'});
            print(result);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
