import 'dart:io';

import 'package:recyclingapp/utils/httpConnector.dart';

class NeuralNetworkConnector {

  File _modelFile;

  NeuralNetworkConnector(this._modelFile);

  Future<dynamic> cataloguePicture(String imagePath) async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getData(File(imagePath));
    return response;
  }

  Future<String> getMaterialList() async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getMaterialsList();
    print(response);
    return response;
  }
}
