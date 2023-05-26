import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../consts.dart';
import '../providers/ImageProvider.dart';
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
  final List<String> _dropdownValues = MATERIALS;

  void _submitForm(context) async {
    var imagePath = context.read<ImagePath>().imagePath;
    ImageManager imageManager = new ImageManager();
    imageManager.saveNewImageWithMetadata(
        imagePath, _selectedValue!, widget.inputController.getTags);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            onPressed:
                _selectedValue == null ? null : () => _submitForm(context),
            child: const Text('Submit'),
          ),
        ),
      ],
    );
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
