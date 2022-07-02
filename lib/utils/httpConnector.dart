import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class HttpConnector {
  HttpConnector(this.image);

  final File image;

  Future getData() async {
    var request =
        new http.MultipartRequest("POST", Uri.http('myserver:8080', '/cnn'));
    request.files.add(new http.MultipartFile.fromBytes(
        'file', await image.readAsBytes(),
        contentType: new MediaType('image', 'jpeg')));

    request.send().then((response) {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          return jsonDecode(value);
        });
      } else {
        print(response.statusCode);
      }
    });
  }
}
