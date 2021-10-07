import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/materialInfoScreen.dart';
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
              style: TEXT_TITLE_THEME,
            ),
            Expanded(
              child: ListView(
                children: [
                  RecyclingMaterialButton(
                    buttonText: 'Plástico',
                    onPress: () {
                      Navigator.pushNamed(context, '/plasticInformationScreen');
                    },
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Vidrio',
                    onPress: () {
                      Navigator.pushNamed(context, '/glassInformationScreen');
                    },
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Cartón',
                    onPress: () {
                      Navigator.pushNamed(
                          context, '/cardboardInformationScreen');
                    },
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Pilas',
                    onPress: () {
                      Navigator.pushNamed(
                          context, '/batteriesInformationScreen');
                    },
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Papel',
                    onPress: () {
                      Navigator.pushNamed(context, '/paperInformationScreen');
                    },
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Metal',
                    onPress: () {
                      Navigator.pushNamed(context, '/metalInformationScreen');
                    },
                  ),
                  RecyclingMaterialButton(
                    buttonText: 'Basura',
                    onPress: () {
                      Navigator.pushNamed(context, '/wasteInformationScreen');
                    },
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
