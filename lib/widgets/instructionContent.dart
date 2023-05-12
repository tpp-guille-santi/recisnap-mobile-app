import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/providers/instructionMarkdownProvider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../screens/feedbackScreen.dart';

void navigateToFeedbackScreen(BuildContext context, PanelController panelController) {
  panelController.close();
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackScreen(),
      ));
}

void sendFeedback(BuildContext context, PanelController panelController) {
  // TODO: Acá hay que mandar la imagen y la metadata
  panelController.close();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Another thing!'),
      duration: const Duration(seconds: 2),
    ),
  );
}

Widget instructionContent(
  ScrollController sc,
  BuildContext context,
    PanelController panelController
) {
  String? materialName =
      context.watch<InstructionMarkdown>().instruction?.materialName;
  bool fromPrediction = context.watch<InstructionMarkdown>().fromPrediction;
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
                'Material ${materialName != null ? materialName.capitalize() : ''}',
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
              data: context.watch<InstructionMarkdown>().instructionMarkdown,
            ),
          ),
          SizedBox(
            height: 36.0,
          ),
          if (true)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button(Icons.thumb_down, Colors.red, ()=> navigateToFeedbackScreen(context, panelController)),
                _button(Icons.thumb_up, Colors.green, ()=> sendFeedback(context, panelController)),
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
