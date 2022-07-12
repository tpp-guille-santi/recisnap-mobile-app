import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/widgets/materialCard.dart';

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
                      title: 'Plástico',
                      body: 'body',
                      image: Image.network(
                          'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/plastic.png')),
                  MaterialCard(
                    title: 'Vidrio',
                    body: 'body2',
                    image: Image.network(
                        'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/glass.png'),
                  ),
                  MaterialCard(
                    title: 'Cartón',
                    body: 'body3',
                    image: Image.network(
                        'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/cardboard.png'),
                  ),
                  MaterialCard(
                      title: 'Pilas',
                      body: 'body3',
                      image: Image.network(
                        'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/batteries.png',
                      )),
                  MaterialCard(
                      title: 'Papel',
                      body: 'body3',
                      image: Image.network(
                          'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/paper.png')),
                  MaterialCard(
                      title: 'Metal',
                      body: 'body3',
                      image: Image.network(
                          'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/metal.png')),
                  MaterialCard(
                      title: 'Basura',
                      body: 'body3',
                      image: Image.network(
                          'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/waste.png'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
