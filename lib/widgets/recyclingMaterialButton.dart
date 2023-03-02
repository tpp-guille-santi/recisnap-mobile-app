import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';

class RecyclingMaterialButton extends StatelessWidget {
  final String buttonText;
  final Function() onPress;

  RecyclingMaterialButton({required this.buttonText, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
