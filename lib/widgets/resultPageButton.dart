import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';

class ResultPageButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;

  ResultPageButton({required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
