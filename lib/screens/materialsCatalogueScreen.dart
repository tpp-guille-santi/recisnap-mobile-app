import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/materialInfoScreen.dart';
import 'package:recyclingapp/widgets/homepagebutton.dart';
import 'package:recyclingapp/widgets/materialCard.dart';
import 'package:recyclingapp/widgets/recyclingMaterialButton.dart';

class MaterialsCatalogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREEN_COLOR,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 60.0,
          right: 60.0,
          top: 40.0,
        ),
        child: Column(
          children: [
            Text(
              'MATERIALES',
              style: TEXT_TITLE_THEME,
            ),
            Expanded(
              child: ListView(
                children: [
                  MaterialCard(
                    title: 'title',
                    body: 'body',
                  ),
                  MaterialCard(
                    title: 'title2',
                    body: 'body2',
                  ),
                  MaterialCard(
                    title: 'title3',
                    body: 'body3',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
