import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../utils/markdownManager.dart';

class ImagePath with ChangeNotifier {
  String _imagePath = "";

  String get imagePath => _imagePath;

  void resetImagePath() {
    _imagePath = "";
    notifyListeners();
  }

  void setImagePath(File image) async {
    MarkdownManager markdownManager = new MarkdownManager();
    _imagePath = image.path;
    notifyListeners();
  }
}
