import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../entities/instructionMetadata.dart';
import '../providers/imageProvider.dart';
import '../providers/instructionProvider.dart';
import '../utils/httpConnector.dart';
import '../utils/neuralNetworkConnector.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen(
      {required this.panelController,
      required this.cameraController,
      required this.cnnConnector});

  final PanelController panelController;
  final NeuralNetworkConnector cnnConnector;
  final CameraController cameraController;

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final HttpConnector httpConnector = HttpConnector();
  bool isLoading = false;

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final scale = 1 /
        (widget.cameraController.value.aspectRatio *
            MediaQuery.of(context).size.aspectRatio);
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              context.read<ImagePath>().resetImagePath();
              setState(() {
                imagePath = null;
              });
              if (widget.panelController.isAttached) {
                widget.panelController.close();
              }
            },
            child: Stack(
              children: [
                Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: CameraPreview(widget.cameraController),
                ),
                if (imagePath != null)
                  Center(
                    child: Image.file(
                      File(imagePath!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (isLoading)
                  const Center(
                    child: SpinKitPulsingGrid(
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final image = await widget.cameraController.takePicture();
              setState(() {
                isLoading = true;
                imagePath = image.path;
              });
              context.read<ImagePath>().setImagePath(image.path);
              final material = widget.cnnConnector.cataloguePicture(image.path);
              final location = Location();
              final locationData = await location.getLocation();
              InstructionMetadata instructionMetadata =
                  await httpConnector.searchInstruction(
                material,
                locationData.latitude,
                locationData.longitude,
              );
              String instructionMarkdown = await httpConnector
                  .getInstructionMarkdown(instructionMetadata.id);
              context.read<Instruction>().resetInstruction();
              context
                  .read<Instruction>()
                  .setInstructionMetadata(instructionMetadata, true);
              context
                  .read<Instruction>()
                  .setInstructionMarkdown(instructionMarkdown);
              setState(() {
                isLoading = false;
              });
              widget.panelController.animatePanelToSnapPoint();
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ));
  }
}
