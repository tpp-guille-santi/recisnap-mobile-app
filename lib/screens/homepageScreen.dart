import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/materialsCatalogueScreen.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _index = 1;
  List<Widget> screens = [Container(), Camera(), MaterialsCatalogue()];

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREEN_COLOR,
      body: screens.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Reciclaje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Catálogo',
          ),
        ],
        currentIndex: _index,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: Colors.black26,
        backgroundColor: DARK_GREEN_COLOR,
      ),
    );
  }
}
