import 'dart:io';

import 'package:recyclingapp/utils/httpConnector.dart';
import 'package:tflite/tflite.dart';

class NeuralNetworkConnector {
  NeuralNetworkConnector(File modelFile, File labelFile) {
    buildModel(modelFile, labelFile);
  }

  Future<String> cataloguePicture(String imagePath) async {
    print("hora de catalogar");
    var results = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (results == null) {
      return "Ups!";
    }
    var labelInfo = results[0];
    print(labelInfo);
    return labelInfo["label"];
  }

  Future<String> getMaterialList() async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getMaterialsList();
    print(response);
    return response;
  }

  Future buildModel(File modelFile, File labelFile) async {
    print(modelFile.path);
    try {
      print("Armando modelo");
      var res = await Tflite.loadModel(
          model: modelFile.path,
          labels: labelFile.path,
          numThreads: 1,
          // defaults to 1
          isAsset: false,
          // defaults to true, set to false to load resources outside assets
          useGpuDelegate:
              false // defaults to false, set to true to use GPU delegate
          );
      print(res);
    } on Exception catch (e) {
      print(e);
      print('Failed to load model.');
    }
  }
}
