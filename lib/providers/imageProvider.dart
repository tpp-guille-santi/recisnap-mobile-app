import 'package:flutter/cupertino.dart';

class ImagePath with ChangeNotifier {
  String? _imagePath;

  String? get imagePath => _imagePath;

  void resetImagePath() {
    _imagePath = "";
    notifyListeners();
  }

  void setImagePath(String imagePath) async {
    _imagePath = imagePath;
    notifyListeners();
  }
}
