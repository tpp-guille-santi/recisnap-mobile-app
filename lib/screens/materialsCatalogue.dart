import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/widgets/homepagebutton.dart';
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
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0),
            ),
            Expanded(
              child: ListView(
                children: [
                  RecyclingMaterialButton(
                    buttonText: 'Plástico',
                    onPress: () {},
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Vidrio',
                    onPress: () {},
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Cartón',
                    onPress: () {},
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Pilas',
                    onPress: () {},
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Papel',
                    onPress: () {},
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Metal',
                    onPress: () {},
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Basura',
                    onPress: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
