import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class HttpConnector {
  getData(File image) async {
    var request = new http.MultipartRequest(
        "POST", Uri.http('192.168.68.101:8000', '/images'));
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        contentType: new MediaType('image', 'jpg')));
    var response = await request.send();
    if (response.statusCode == 200) {
      String serverResponse = await response.stream.bytesToString();
      return jsonDecode(serverResponse);
    } else {
      print(response.statusCode);
    }
  }

  getMarkdown(String material) async {
    http.Response response = await http.get(Uri.http(
        "raw.githubusercontent.com",
        "/tpp-guille-santi/materials/main/$material.md"));

    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.statusCode);
    }
  }
}
