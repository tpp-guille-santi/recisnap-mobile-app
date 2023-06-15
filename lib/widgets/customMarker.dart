import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomMarker extends StatelessWidget {
  final String materialName;
  final Function onPressed;

  CustomMarker({
    required this.materialName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: SvgPicture.asset('assets/icons/$materialName.svg'),
        iconSize: 32,
        onPressed: () => onPressed(),
      ),
    ]);
  }
}
