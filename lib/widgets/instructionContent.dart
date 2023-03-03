import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:recyclingapp/utils/markdownManager.dart';

class InstructionContent extends StatelessWidget {
  final MarkdownManager markdownManager = new MarkdownManager();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: new EdgeInsets.all(20.0),
        child: FutureBuilder<String>(
          future: markdownManager.getRecyclingInformation(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MarkdownBody(data: 'Cargando...',
              );
            } else {
              if (snapshot.hasError)
                return MarkdownBody(data: 'Error: ${snapshot.error}');
              else
                return MarkdownBody(
                  data: '${snapshot.data}',
                ); // snapshot.data  :- get your object which is pass from your downloadData() function
            }
          },
        ),
      ),
    );
  }
}
