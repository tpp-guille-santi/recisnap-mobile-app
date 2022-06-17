import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Container(
      child: Column(
        children: [
          TextButton(
            onPressed: () => {Navigator.pop(context, arguments['cameraIndex'])},
            child: Text('Camara'),
          ),
          TextButton(
            onPressed: () =>
                {Navigator.pop(context, arguments['catalogueIndex'])},
            child: Text('Catalogo'),
          ),
        ],
      ),
    );
  }
}
