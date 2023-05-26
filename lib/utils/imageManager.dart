import 'dart:async';
import 'dart:io';

import 'package:recyclingapp/utils/httpConnector.dart';
import 'package:uuid/uuid.dart';

import '../entities/image.dart';

class ImageManager {
  Future<void> saveNewImageWithMetadata(
      String imagePath, String materialName, List<String>? tags) async {
    HttpConnector httpConnector = HttpConnector();
    var file = File(imagePath);
    var uuid = Uuid().v4();
    var fileExtension = file.path.split('.').last;
    var filename = '$uuid.$fileExtension';
    var image = Image(filename, materialName, tags);
    await httpConnector.saveImage(filename, fileExtension, file);
    await httpConnector.saveImageMetadata(image);
  }
}
