import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  final CameraController? controller;
  final Future<void>? future;

  CameraScreen({required this.future, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(controller!);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
