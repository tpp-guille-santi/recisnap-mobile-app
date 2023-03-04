import 'package:flutter/material.dart';
import 'package:recyclingapp/screens/homepageScreen.dart';

import 'screens/resultScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: Homepage(),
      routes: <String, WidgetBuilder>{
        '/results': (BuildContext context) => ResultScreen(),
        '/catalogue': (BuildContext context) => Homepage()
      },
    );
  }
}
