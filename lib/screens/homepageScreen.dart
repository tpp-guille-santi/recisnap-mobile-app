import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/screens/cameraScreen.dart';
import 'package:recyclingapp/screens/materialsCatalogueScreen.dart';
import 'package:recyclingapp/widgets/homepagebutton.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREEN_COLOR,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Image.network(
                  'https://static.wikia.nocookie.net/mtgsalvation_gamepedia/images/8/88/G.svg/revision/latest/scale-to-width-down/200?cb=20160125094907'),
              HomepageButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Camera();
                  }));
                },
                buttonText: 'Sacar foto',
              ),
              HomepageButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MaterialsCatalogue();
                  }));
                },
                buttonText: 'Ver materiales',
              ),
              HomepageButton(
                onPressed: () {},
                buttonText: '¿Por que reciclar?',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
