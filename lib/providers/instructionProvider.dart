import 'package:flutter/cupertino.dart';

import '../consts.dart';
import '../entities/instructionMetadata.dart';

class Instruction with ChangeNotifier {
  InstructionMetadata? _instructionMetadata;
  String _instructionMarkdown = LOADING_MESSAGE;
  bool _fromPrediction = false;

  InstructionMetadata? get instructionMetadata => _instructionMetadata;

  String get instructionMarkdown => _instructionMarkdown;

  bool get fromPrediction => _fromPrediction;

  void resetInstruction() {
    _instructionMarkdown = LOADING_MESSAGE;
    _instructionMetadata = null;
    notifyListeners();
  }

  void setInstructionMetadata(
      InstructionMetadata instructionMetadata, bool fromPrediction) async {
    _instructionMetadata = instructionMetadata;
    _fromPrediction = fromPrediction;
    notifyListeners();
  }

  void setInstructionMarkdown(String instructionMarkdown) async {
    _instructionMarkdown = instructionMarkdown;
    _fromPrediction = fromPrediction;
    notifyListeners();
  }
}
