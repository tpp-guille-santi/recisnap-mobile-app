import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as location_package;
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
      required this.cnnConnector,
      required this.cameraController,
      required this.cameraControllerFuture});

  final PanelController panelController;
  final NeuralNetworkConnector cnnConnector;
  final CameraController cameraController;
  final Future<void> cameraControllerFuture;

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  MarkdownManager markdownManager = new MarkdownManager();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String? imagePath = context.watch<ImagePath>().imagePath;
    return FutureBuilder<void>(
        future: widget.cameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final scale = 1 /
              (widget.cameraController.value.aspectRatio *
                  MediaQuery.of(context).size.aspectRatio);
          return Scaffold(
              body: GestureDetector(
                  onTap: () {
                    context.read<ImagePath>().resetImagePath();
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
                            File(imagePath),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (_isLoading)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  )),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    final image = await widget.cameraController.takePicture();
                    context.read<ImagePath>().setImagePath(image.path);
                    //Mandar a red
                    print("saque foto");
                    var material =
                        await widget.cnnConnector.cataloguePicture(image.path);
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
                    widget.panelController.animatePanelToSnapPoint();
                    //Mostrar el resultado al usuario
                    InstructionMarkdown provider = InstructionMarkdown();
                    provider.setInstructionMarkdown(instruction);
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ));
        });
  }
}
