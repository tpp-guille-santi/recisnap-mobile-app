import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyFormWidget extends StatefulWidget {
  final TextEditingController inputController;

  const MyFormWidget({Key? key, required this.inputController}) : super(key: key);

  @override
  _MyFormWidgetState createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  String? _selectedValue;
  final List<String> _dropdownValues = ['Value 1', 'Value 2', 'Value 3'];

  void _submitForm() async {
    final url = Uri.parse('https://my-backend-url.com/submit');
    final response = await http.post(url, body: {
      'input': widget.inputController.text,
      'dropdown': _selectedValue ?? '',
    });
    final responseBody = json.decode(response.body);
    // handle response here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.inputController,
          decoration: const InputDecoration(
            labelText: 'Input field',
          ),
        ),
        DropdownButtonFormField<String>(
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
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  final TextEditingController inputController = TextEditingController();

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