import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/widgets/materialCard.dart';

class MaterialsCatalogue extends StatelessWidget {
  Widget getList() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Please wait its loading...');
        }

        List<dynamic> result = jsonDecode(snapshot.data!);
        return ListView.builder(
            itemCount: result.length,
            itemBuilder: (context, index) {
              return MaterialCard(
                  title: result[index]['name'],
                  body: 'body',
                  image: Image.network(
                      'https://raw.githubusercontent.com/tpp-guille-santi/materials/main/iconos/${result[index]['name']}.png'));
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: getList(),
            ),
          ],
        ),
      ),
    );
  }
}
