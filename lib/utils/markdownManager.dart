import 'package:recyclingapp/utils/httpConnector.dart';

import '../entities/instruction.dart';

class MarkdownManager {
  Future<String> getInstructions(String material) async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getMarkdown(material);
    return response;
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
