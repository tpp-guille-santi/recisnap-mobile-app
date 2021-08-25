import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/homepage.dart';

class HomepageButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;

  HomepageButton({this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        style: TextButton.styleFrom(
          minimumSize: Size(double.infinity, 30),
          backgroundColor: DARK_GREEN_COLOR,
        ),
      ),
    );
  }
}
