import 'package:recyclingapp/utils/httpConnector.dart';

import '../entities/instruction.dart';

class MarkdownManager {
  Future<String> getInstructions(String material) async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getMarkdown(material);
    return response;
  }

  Future<Instruction> getInstruction(
      String material, dynamic latitude, dynamic longitude) async {
    HttpConnector networkHelper = HttpConnector();
    var instructionResponse =
        await networkHelper.searchInstruction(material, latitude, longitude);
    await networkHelper.searchInstruction(material, latitude, longitude);
    return instructionResponse;
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
