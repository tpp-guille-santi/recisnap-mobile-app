import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';
import 'package:recyclingapp/widgets/homepagebutton.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREEN_COLOR,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Image.network(
                'https://static.wikia.nocookie.net/mtgsalvation_gamepedia/images/8/88/G.svg/revision/latest/scale-to-width-down/200?cb=20160125094907'),
            HomepageButton(
              onPressed: null,
              buttonText: 'Sacar foto',
            ),
            HomepageButton(
              onPressed: null,
              buttonText: 'Ver materiales',
            ),
            HomepageButton(
              onPressed: null,
              buttonText: '¿Por que reciclar?',
            ),
          ],
        ),
      ),
    );
  }
}
