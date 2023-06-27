import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../entities/instruction.dart';
import '../providers/imageProvider.dart';
import '../providers/instructionMarkdownProvider.dart';
import '../utils/markdownManager.dart';
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
  MarkdownManager markdownManager = MarkdownManager();
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
              Instruction instruction = await markdownManager.getInstruction(
                material,
                locationData.latitude,
                locationData.longitude,
              );
              context.read<InstructionMarkdown>().resetInstructionMarkdown();
              context
                  .read<InstructionMarkdown>()
                  .setInstruction(instruction, true);
              context
                  .read<InstructionMarkdown>()
                  .setInstructionMarkdown(instruction);
              setState(() {
                isLoading = false;
              });
              widget.panelController.animatePanelToSnapPoint();
              InstructionMarkdown provider = InstructionMarkdown();
              provider.setInstructionMarkdown(instruction);
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ));
  }
}
