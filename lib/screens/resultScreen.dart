import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:recyclingapp/widgets/resultPageButton.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      bottomSheet: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ResultPageButton(
              onPressed: () =>
                  {Navigator.pop(context, arguments['cameraIndex'])},
              buttonText: 'Volver a la Cámara',
            ),
            ResultPageButton(
              onPressed: () =>
                  {Navigator.pop(context, arguments['catalogueIndex'])},
              buttonText: 'Volver al Catálogo',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 40.0,
        ),
        child: Markdown(data: arguments["instructions"]),
      ),
    );
  }
}
