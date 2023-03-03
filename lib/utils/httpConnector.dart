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
    print("F");
    http.Response response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/tpp-guille-santi/materials/main/recycling.md"));

    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print(response.body);
      print(response.toString());
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

  searchInstructions(lat, lon) async {
    var url = 'https://recisnap-1-y9816629.deta.app/instructions/search';

    Map data = {
      "lat": lat,
      "lon": lon,
      "max_distance": MAX_DISTANCE,
    };
    //encode Map to JSON
    print(data);
    var body = json.encode(data);
    http.Response response = await http.post(Uri.parse(url),
        body: body,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    if (response.statusCode == 200) {
      body = await response.body;
      List<Instruction> instructions = List<Instruction>.from(
          json.decode(body)
              .map((instruction) => Instruction.fromJson(instruction))
      );
      for(Instruction instruction in instructions){
        print(instruction.toJson().toString());
      }

      return instructions;
    } else {
      print(response.statusCode);
      return [];
    }
  }
}
