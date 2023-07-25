import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../consts.dart';
import '../entities/image.dart';
import '../entities/instructionMetadata.dart';
import '../entities/material.dart';

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

  saveImage(String filename, String fileExtension, File image) async {
    var url = '$BACKEND_URL/images/file/$filename/';
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        contentType: new MediaType('image', fileExtension)));
    var response = await request.send();
    if (response.statusCode != 200) {
      print(response.statusCode);
    }
  }

  saveImageMetadata(Image image) async {
    var url = '$BACKEND_URL/images/';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(image.toJson());
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode != 201) {
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

  Future<String> getHomeMarkdown() async {
    http.Response response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/tpp-guille-santi/materials/main/recycling.md"));

    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.statusCode);
      return "";
    }
  }

  getMaterialsList() async {
    var url = '$BACKEND_URL/materials/';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = response.body;
      List<RecyclableMaterial> materials = List<RecyclableMaterial>.from(json
          .decode(body)
          .map((materials) => RecyclableMaterial.fromJson(materials)));
      return materials;
    } else {
      print(response.statusCode);
    }
  }

  getMaterials() async {
    var url = '$BACKEND_URL/materials/';
    http.Response response = await http.get(
      Uri.https(url),
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

  searchInstructions(lat, lon, String? materialName) async {
    var url = '$BACKEND_URL/instructions/search/';
    Map data = {
      "material_name": materialName,
      "lat": lat,
      "lon": lon,
      "max_distance": MAX_DISTANCE,
    };
    var headers = {HttpHeaders.contentTypeHeader: "application/json"};
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(data), headers: headers);
    if (response.statusCode == 200) {
      var body = response.body;
      List<InstructionMetadata> instructions = List<InstructionMetadata>.from(
          json
              .decode(body)
              .map((instruction) => InstructionMetadata.fromJson(instruction)));
      return instructions;
    } else {
      return [];
    }
  }

  searchInstruction(material, lat, lon) async {
    var url = '$BACKEND_URL/instructions/search/';
    Map data = {
      "material_name": material,
      "lat": lat,
      "lon": lon,
      "max_distance": MAX_DISTANCE,
    };
    var headers = {HttpHeaders.contentTypeHeader: "application/json"};
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(data), headers: headers);
    if (response.statusCode == 200) {
      var body = response.body;
      InstructionMetadata instruction = List<InstructionMetadata>.from(json
          .decode(body)
          .map((instruction) => InstructionMetadata.fromJson(instruction)))[0];
      return instruction;
    } else {
      return null;
    }
  }
}
