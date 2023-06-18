import 'package:flutter/cupertino.dart';

import '../entities/material.dart';

class MaterialsProvider extends ChangeNotifier {
  List<RecyclableMaterial> materials = [];

  void setMaterials(List<RecyclableMaterial> newMaterials) {
    materials = newMaterials;
    notifyListeners();
  }
}
