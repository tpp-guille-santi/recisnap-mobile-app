import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../consts.dart';
import '../entities/instructionMetadata.dart';
import '../providers/imageProvider.dart';
import '../providers/instructionProvider.dart';
import '../utils/httpConnector.dart';
import '../utils/neuralNetworkConnector.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen(
      {required this.panelController,
      required this.scrollController,
      required this.cameraController,
      required this.cnnConnector});

  final PanelController panelController;
  final ScrollController scrollController;
  final NeuralNetworkConnector cnnConnector;
  final CameraController cameraController;

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  bool _showFocusCircle = false;
  double _x = 0;
  double _y = 0;
  final HttpConnector httpConnector = HttpConnector();
  bool isLoading = false;

  Future<void> _onTap(TapUpDetails details) async {
    if (!isLoading && widget.cameraController.value.isInitialized) {
      // Remove widget and hide instructions on tap functionality
      context.read<ImagePath>().resetImagePath();
      if (widget.panelController.isAttached) {
        widget.panelController.close();
      }

      // Tap-to-focus functionality
      setState(() {
        _showFocusCircle = true;
        _x = details.localPosition.dx;
        _y = details.localPosition.dy;
      });

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = MediaQuery.of(context).size.height;

      double xp = _x / fullWidth;
      double yp = _y / cameraHeight;

      // Ensure the coordinates are within the range (0,0) to (1,1)
      xp = xp.clamp(0.0, 1.0);
      yp = yp.clamp(0.0, 1.0);

      Offset point = Offset(xp, yp);

      // Manually focus
      await widget.cameraController.setFocusPoint(point);

      // Manually set light exposure
      widget.cameraController.setExposurePoint(point);

      // Use a Timer to hide the focus circle after 2 seconds
      Timer(const Duration(seconds: 2), () {
        setState(() {
          _showFocusCircle = false;
        });
      });
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await widget.cameraController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1 /
        (widget.cameraController.value.aspectRatio *
            MediaQuery.of(context).size.aspectRatio);
    String? imagePath = context.watch<ImagePath>().imagePath;
    return Scaffold(
        body: GestureDetector(
            onTapUp: _onTap,
            child: Stack(
              children: [
                // 0. Transparent overlay to capture taps in whole screen
                Container(
                  color: Colors.transparent,
                ),

                // 1. Camera Preview
                Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: CameraPreview(widget.cameraController),
                ),

                // 2. Focus Circle
                if (_showFocusCircle)
                  Positioned(
                    top: _y - 20,
                    left: _x - 20,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
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
              });
              context.read<ImagePath>().setImagePath(image.path);
              final material = widget.cnnConnector.cataloguePicture(image.path);
              final location = Location();
              final locationData = await location.getLocation();
              InstructionMetadata? instructionMetadata =
                  await httpConnector.searchInstruction(
                material,
                locationData.latitude,
                locationData.longitude,
              );
              context.read<Instruction>().resetInstruction();
              if (instructionMetadata != null) {
                String instructionMarkdown = await httpConnector
                    .getInstructionMarkdown(instructionMetadata.id);
                context.read<Instruction>().setInstructionMetadata(
                    instructionMetadata, material, true);
                context
                    .read<Instruction>()
                    .setInstructionMarkdown(instructionMarkdown);
              } else {
                context
                    .read<Instruction>()
                    .setInstructionMetadata(null, material, false);
                context
                    .read<Instruction>()
                    .setInstructionMarkdown(NO_INSTRUCTIONS);
              }

              setState(() {
                isLoading = false;
              });
              widget.scrollController.jumpTo(0);
              widget.panelController.animatePanelToSnapPoint();
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
