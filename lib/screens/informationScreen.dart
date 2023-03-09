import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:recyclingapp/utils/markdownManager.dart';

class InformationScreen extends StatelessWidget {
  final MarkdownManager markdownManager = new MarkdownManager();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: FutureBuilder<String>(
          future: markdownManager.getRecyclingInformation(),
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
      ),
    );
  }
}
