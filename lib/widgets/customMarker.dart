import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final Function onPressed;

  CustomMarker({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.location_on_outlined,
          size: 40,
          color: Color(0xff143017),
        ),
        onPressed: () => onPressed(),
      ),
      IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.location_on,
          size: 40,
          color: Color(0xff279632),
        ),
        onPressed: () => onPressed(),
      ),
    ]);
  }
}
