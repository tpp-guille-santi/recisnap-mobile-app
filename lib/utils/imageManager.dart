import 'package:recyclingapp/utils/httpConnector.dart';

import '../entities/instruction.dart';

class ImageManager {
  Future<String> saveNewImageWithMetadata(String imagePath, Instruction instruction) async {
    HttpConnector httpConnector = HttpConnector();
    return "";
    // var response = await httpConnector.saveImage(File(imagePath));
    // var response = await httpConnector.saveImageMetadata(material);
    // return response;
  }

  Future<String> getRecyclingInformation() async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getRecyclingMarkdown();
    return response;
  }

  Future<String> getInstructionMarkdown(Instruction? instruction) async {
    HttpConnector networkHelper = HttpConnector();
    var response = await networkHelper.getInstructionMarkdown(instruction!.id);
    return response;
  }
}
