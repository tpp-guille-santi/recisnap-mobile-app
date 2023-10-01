import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../entities/material.dart';
import 'httpConnector.dart';

class NeuralNetworkConnector {
  late Interpreter interpreter;
  late List<String> labels;

  NeuralNetworkConnector(File modelFile) {
    buildModel(modelFile);
  }

  Future<void> buildModel(File modelFile) async {
    final options = InterpreterOptions();
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }
    if (Platform.isAndroid) {
      options.addDelegate(GpuDelegateV2());
    }
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }
    this.interpreter = Interpreter.fromFile(modelFile, options: options);
    HttpConnector httpConnector = HttpConnector();
    List<RecyclableMaterial> materials = await httpConnector.getMaterialsList();
    this.labels = materials.map((material) => material.name).toList();
  }

  String cataloguePicture(String imagePath) {
    final imageData = File(imagePath).readAsBytesSync();
    img.Image? image = img.decodeImage(imageData);
    final imageInput = img.copyResize(
      image!,
      width: 224,
      height: 224,
    );
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );
    return runInference(imageMatrix);
  }

  String runInference(List<List<List<num>>> imageMatrix) {
    final input = [imageMatrix];
    final output = [List<int>.filled(labels.length, 0)];
    interpreter.run(input, output);
    final result = output.first;
    int maxIndex = result
        .asMap()
        .entries
        .reduce((maxEntry, entry) =>
            entry.value > maxEntry.value ? entry : maxEntry)
        .key;
    return labels[maxIndex];
  }
}
