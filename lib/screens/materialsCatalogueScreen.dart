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
                      title: 'Plástico',
                      body: 'body',
                      image: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/1996/1996869.png')),
                  MaterialCard(
                    title: 'Vidrio',
                    body: 'body2',
                    image: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/85/85843.png'),
                  ),
                  MaterialCard(
                    title: 'Cartón',
                    body: 'body3',
                    image: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/65/65686.png'),
                  ),
                  MaterialCard(
                      title: 'Pilas',
                      body: 'body3',
                      image: Image.network(
                        'https://static.thenounproject.com/png/187466-200.png',
                      )),
                  MaterialCard(
                      title: 'Papel',
                      body: 'body3',
                      image: Image.network(
                          'https://thumbs.dreamstime.com/b/document-icon-vector-illustration-design-flat-paper-icon-vector-document-icon-vector-illustration-design-flat-paper-icon-vector-164319261.jpg')),
                  MaterialCard(
                      title: 'Metal',
                      body: 'body3',
                      image: Image.network(
                          'https://www.pikpng.com/pngl/b/287-2878853_png-icon-the-metal-icon-clipart.png')),
                  MaterialCard(
                      title: 'Basura',
                      body: 'body3',
                      image: Image.network(
                          'https://png.pngtree.com/png-vector/20190326/ourlarge/pngtree-vector-trash-icon-png-image_865253.jpg'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
