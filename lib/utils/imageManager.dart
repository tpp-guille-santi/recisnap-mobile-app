import 'dart:async';
import 'dart:io';

import 'package:recyclingapp/utils/httpConnector.dart';
import 'package:uuid/uuid.dart';

import '../entities/image.dart';
import '../entities/instruction.dart';

class ImageManager {
  Future<void> saveNewImageWithMetadata(
      String imagePath, Instruction instruction, List<String>? tags) async {
    HttpConnector httpConnector = HttpConnector();
    var file = File(imagePath);
    var uuid = Uuid().v4();
    var fileExtension = file.path.split('.').last;
    var filename = '$uuid.$fileExtension';
    var image = Image(filename, instruction.materialName, tags);
    await httpConnector.saveImage(filename, fileExtension, file);
    await httpConnector.saveImageMetadata(image);
  }
}
