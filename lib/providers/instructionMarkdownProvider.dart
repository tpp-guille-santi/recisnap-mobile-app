import 'package:flutter/cupertino.dart';

import '../consts.dart';
import '../entities/instruction.dart';
import '../utils/markdownManager.dart';

class InstructionMarkdown with ChangeNotifier {
  Instruction? _instruction;
  String _instructionMarkdown = LOADING_MESSAGE;
  bool _fromPrediction = false;

  Instruction? get instruction => _instruction;

  String get instructionMarkdown => _instructionMarkdown;

  bool get fromPrediction => _fromPrediction;

  void resetInstructionMarkdown() {
    _instructionMarkdown = LOADING_MESSAGE;
    notifyListeners();
  }

  void setInstructionMarkdown(Instruction instruction) async {
    MarkdownManager markdownManager = new MarkdownManager();
    _instructionMarkdown = LOADING_MESSAGE;
    _instructionMarkdown =
        await markdownManager.getInstructionMarkdown(instruction);
    notifyListeners();
  }

  void setInstruction(Instruction instruction, bool fromPrediction) {
    _instruction = instruction;
    _fromPrediction = fromPrediction;
    notifyListeners();
  }
}
