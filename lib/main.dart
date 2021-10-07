import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/homepageScreen.dart';
import 'package:recyclingapp/screens/materialInfoScreen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
      routes: <String, WidgetBuilder>{
        '/plasticInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'PLÁSTICO',
              body: PLASTIC_INFORMATION,
            ),
        '/glassInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'VIDRIO',
              body: GLASS_INFORMATION,
            ),
        '/cardboardInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'CARTÓN',
              body: CARDBOARD_INFORMATION,
            ),
        '/batteriesInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'PILAS',
              body: BATTERIES_INFORMATION,
            ),
        '/paperInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'PAPEL',
              body: PAPER_INFORMATION,
            ),
        '/metalInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'METAL',
              body: METAL_INFORMATION,
            ),
        '/wasteInformationScreen': (BuildContext context) =>
            MaterialInformationScreen(
              title: 'BASURA',
              body: WASTE_INFORMATION,
            )
      },
    );
  }
}
