import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/entities/instructionMetadata.dart';
import 'package:recyclingapp/providers/imageProvider.dart';
import 'package:recyclingapp/providers/instructionProvider.dart';
import 'package:recyclingapp/utils/imageManager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../screens/feedbackScreen.dart';

void navigateToFeedbackScreen(
    BuildContext context, PanelController? panelController) {
  if (panelController != null && panelController.isAttached) {
    panelController.close();
  }
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackScreen(),
      ));
}

void sendFeedback(BuildContext context, PanelController? panelController,
    String? materialName, String? imagePath) async {
  if (materialName == null || imagePath == null) {
    return;
  }
  ImageManager imageManager = new ImageManager();
  await imageManager.saveNewImageWithMetadata(imagePath, materialName, null);
  if (panelController != null && panelController.isAttached) {
    panelController.close();
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(SENT_FEEDBACK_SUCCESSFULLY),
      duration: const Duration(seconds: 2),
    ),
  );
}

typedef void OnScreenChangeCallback(InstructionMetadata instructionMetadata);

Widget instructionContent(ScrollController sc, BuildContext context,
    PanelController panelController, OnScreenChangeCallback onScreenChange) {
  InstructionMetadata? instructionMetadata =
      context.watch<Instruction>().instructionMetadata;
  bool fromPrediction = context.watch<Instruction>().fromPrediction;
  String? imagePath = context.watch<ImagePath>().imagePath;
  return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 18.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                instructionMetadata == null
                    ? ''
                    : 'Material ${instructionMetadata.materialName}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          Container(
            padding: new EdgeInsets.all(20.0),
            child: MarkdownBody(
              data: context.watch<Instruction>().instructionMarkdown,
            ),
          ),
          SizedBox(
            height: 36.0,
          ),
          if (fromPrediction)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (instructionMetadata != null)
                  _button(Icons.thumb_down, Colors.red,
                      () => navigateToFeedbackScreen(context, panelController)),
                if (instructionMetadata != null)
                  _button(
                      Icons.thumb_up,
                      Colors.green,
                      () => sendFeedback(context, panelController,
                          instructionMetadata.materialName, imagePath)),
                if (instructionMetadata != null)
                  _button(
                    Icons.map_outlined,
                    Colors.blueGrey,
                    () {
                      onScreenChange(instructionMetadata);
                      // Con esto hacemos que haga scroll de la instrucción
                      // hasta arriba en el cambio de pantalla.
                      sc.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
              ],
            ),
          SizedBox(
            height: 24,
          ),
        ],
      ));
}

Widget _button(IconData icon, Color color, Function() onPressedCallback) {
  return ElevatedButton(
    child: Icon(
      icon,
      color: Colors.white,
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(16.0),
      shape: CircleBorder(),
    ),
    onPressed: onPressedCallback,
  );
}
