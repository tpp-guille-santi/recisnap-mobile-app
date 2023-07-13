import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/providers/imageProvider.dart';
import 'package:recyclingapp/providers/instructionProvider.dart';
import 'package:recyclingapp/screens/homepageScreen.dart';

import 'firebase_options.dart';
import 'screens/resultScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Instruction()),
      ChangeNotifierProvider(create: (_) => ImagePath())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // Define your seed colors.
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
