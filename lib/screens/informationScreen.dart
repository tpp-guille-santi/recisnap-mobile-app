import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../utils/httpConnector.dart';

class InformationScreen extends StatelessWidget {
  final HttpConnector httpConnector = HttpConnector();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        child: FutureBuilder<String>(
          future: httpConnector.getHomeMarkdown(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Markdown(data: 'Please wait its loading...');
            } else {
              if (snapshot.hasError)
                return Markdown(data: 'Error: ${snapshot.error}');
              else
                return Markdown(
                  data: '${snapshot.data}',
                );
            }
          },
        ),
      )),
    );
  }
}
