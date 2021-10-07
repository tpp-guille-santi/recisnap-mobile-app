import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';

class MaterialInformationScreen extends StatelessWidget {
  final String title;
  final String body;

  MaterialInformationScreen({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREEN_COLOR,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Text(
                title,
                style: TEXT_TITLE_THEME,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(body),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
