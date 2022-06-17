import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(arguments);
    return Container(
      child: TextButton(
          onPressed: () => {Navigator.pop(context)},
          child: Text(arguments['test'])),
    );
  }
}
