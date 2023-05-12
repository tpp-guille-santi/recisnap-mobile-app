import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/providers/instructionMarkdownProvider.dart';

Widget feedbackContent(
  ScrollController sc,
  BuildContext context,
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
          if (fromPrediction)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button(Icons.thumb_down, Colors.red),
                _button(Icons.thumb_up, Colors.green),
              ],
            ),
          SizedBox(
            height: 24,
          ),
        ],
      ));
}

Widget _button(IconData icon, Color color) {
  return Column(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          icon,
          color: Colors.white,
        ),
        decoration:
            BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 8.0,
          )
        ]),
      ),
      SizedBox(
        height: 12.0,
      ),
    ],
  );
}
