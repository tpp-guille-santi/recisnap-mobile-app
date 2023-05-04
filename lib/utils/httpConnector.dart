import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../consts.dart';
import '../entities/instruction.dart';

class HttpConnector {
  getData(File image) async {
    var request = new http.MultipartRequest(
        "POST", Uri.https('peaceful-refuge-34158.herokuapp.com', '/images'));
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
        "/tpp-guille-santi/materials/main/resultados/$material.md"));

    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.statusCode);
    }
  }

  getRecyclingMarkdown() async {
    http.Response response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/tpp-guille-santi/materials/main/recycling.md"));

    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.statusCode);
    }
  }

  getMaterialsList() async {
    http.Response response = await http.get(
      Uri.https('peaceful-refuge-34158.herokuapp.com', '/materials'),
    );
    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.statusCode);
    }
  }

  getInstructionMarkdown(String id) async {
    var url = '$BACKEND_URL/instructions/$id/markdown/';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var instructionMarkdown = response.body;
      return instructionMarkdown;
    } else {
      return '';
    }
  }

  searchInstructions(lat, lon) async {
    var url = '$BACKEND_URL/instructions/search/';
    Map data = {
      "lat": lat,
      "lon": lon,
      "max_distance": MAX_DISTANCE,
    };
    var headers = {HttpHeaders.contentTypeHeader: "application/json"};
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(data), headers: headers);
    if (response.statusCode == 200) {
      var body = response.body;
      List<Instruction> instructions = List<Instruction>.from(json
          .decode(body)
          .map((instruction) => Instruction.fromJson(instruction)));
      return instructions;
    } else {
      return [];
    }
  }
}
