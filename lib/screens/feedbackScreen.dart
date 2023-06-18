import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/providers/imageProvider.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../consts.dart';
import '../entities/material.dart';
import '../utils/httpConnector.dart';
import '../utils/imageManager.dart';

class MyFormWidget extends StatefulWidget {
  final TextfieldTagsController inputController;

  const MyFormWidget({Key? key, required this.inputController})
      : super(key: key);

  @override
  _MyFormWidgetState createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  String? _selectedValue;
  List<String> _dropdownValues = [];

  @override
  void initState() {
    super.initState();
    setMaterials();
  }

  void _submitForm(context, String? imagePath) async {
    if (imagePath != null) {
      ImageManager imageManager = new ImageManager();
      imageManager.saveNewImageWithMetadata(
          imagePath, _selectedValue!, widget.inputController.getTags);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(SENT_FEEDBACK_SUCCESSFULLY),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? imagePath = context.read<ImagePath>().imagePath;
    return ListView(
      children: [
        Center(
          child: Image.file(
            File(imagePath!),
            width: 200, // Set the desired width
            height: 200, // Set the desired height
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 16.0), // Add desired padding/margin
          child: TextFieldTags(
            textfieldTagsController: widget.inputController,
            textSeparators: const [' ', ','],
            inputfieldBuilder:
                (context, tec, fn, error, onChanged, onSubmitted) {
              return ((context, sc, tags, onTagDelete) {
                return TextField(
                  controller: tec,
                  focusNode: fn,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText:
                        widget.inputController.hasTags ? '' : "Enter tag...",
                    errorText: error,
                    prefixIcon: tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: sc,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: tags.map((String tag) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: Color(0xff1b5e20),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        '#$tag',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        //print("$tag selected");
                                      },
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        onTagDelete(tag);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                          )
                        : null,
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                );
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 16.0), // Add desired padding/margin
          child: DropdownButtonFormField<String>(
            value: _selectedValue,
            onChanged: (newValue) {
              setState(() {
                _selectedValue = newValue;
              });
            },
            items: _dropdownValues
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Dropdown field',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 16.0), // Add desired padding/margin
          child: ElevatedButton(
            onPressed: _selectedValue == null
                ? null
                : () => _submitForm(context, imagePath),
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  Future<void> setMaterials() async {
    HttpConnector httpConnector = HttpConnector();
    List<RecyclableMaterial> materials = await httpConnector.getMaterialsList();
    setState(() {
      _dropdownValues = materials.map((material) => material.name).toList();
      _dropdownValues.add('otro');
    });
  }
}

class FeedbackScreen extends StatelessWidget {
  final TextfieldTagsController inputController = TextfieldTagsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            child: MyFormWidget(inputController: inputController),
          ),
        ),
      ),
    );
  }
}
