import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';

class MaterialCard extends StatelessWidget {
  String title;
  String body;

  MaterialCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.greenAccent,
        onTap: () {
          print('Card tapped.');
        },
        child: SizedBox(
          width: 300,
          height: 100,
          child: Column(
            children: [Text(title), Text(body)],
          ),
        ),
      ),
    );
  }
}
