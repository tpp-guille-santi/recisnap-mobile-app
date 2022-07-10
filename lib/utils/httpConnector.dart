import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class HttpConnector {
  HttpConnector(this.image);

  final File image;

  getData() async {
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
}
