import 'dart:io';

import 'package:recyclingapp/utils/httpConnector.dart';

class MarkdownManager {
  Future<String> getInstructions(String material) async {
    HttpConnector networkHelper = HttpConnector();

    var response = await networkHelper.getMarkdown(material);
    return response;
  }
}
