import 'package:flutter/material.dart';
import 'package:recyclingapp/consts.dart';

class MaterialCard extends StatelessWidget {
  String title;
  String body;
  Image image;

  MaterialCard({required this.title, required this.body, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.greenAccent,
        onTap: () {
          print('Card tapped.');
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Material'),
              content: Scrollbar(
                child: SingleChildScrollView(
                  child: const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce egestas vestibulum purus nec facilisis. Mauris interdum libero ut massa venenatis, nec dapibus sem tempor. In aliquam faucibus lectus in tincidunt. Ut vehicula eros lacus, vitae sodales tortor pharetra ac. Nam risus purus, ornare non dolor ac, porta mattis urna. Donec ullamcorper consectetur velit a efficitur. Nulla vel efficitur ligula. Vivamus vel consequat diam. Nam faucibus turpis felis, eget elementum quam lacinia ac. Aliquam ultrices ipsum tincidunt facilisis maximus. Ut rutrum ut sem at efficitur. Proin ullamcorper tristique neque at maximus. Duis convallis dapibus sapien, a euismod erat volutpat et. Aenean quis rutrum est, et tempor neque. Suspendisse imperdiet suscipit varius.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce egestas vestibulum purus nec facilisis. Mauris interdum libero ut massa venenatis, nec dapibus sem tempor. In aliquam faucibus lectus in tincidunt. Ut vehicula eros lacus, vitae sodales tortor pharetra ac. Nam risus purus, ornare non dolor ac, porta mattis urna. Donec ullamcorper consectetur velit a efficitur. Nulla vel efficitur ligula. Vivamus vel consequat diam. Nam faucibus turpis felis, eget elementum quam lacinia ac. Aliquam ultrices ipsum tincidunt facilisis maximus. Ut rutrum ut sem at efficitur. Proin ullamcorper tristique neque at maximus. Duis convallis dapibus sapien, a euismod erat volutpat et. Aenean quis rutrum est, et tempor neque. Suspendisse imperdiet suscipit varius.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: SizedBox(
          width: 300,
          height: 125,
          child: Column(
            children: [
              Text(title),
              Row(
                children: <Widget>[
                  Container(
                    child: image,
                    height: 100.0,
                    width: 100.0,
                  ),
                  Text(body),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
