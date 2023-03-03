import 'instruction.dart';

class Instructions {
  final List<Instruction> instructions;

  Instructions(this.instructions);

  Instructions.fromJson(List<dynamic> json)
      : instructions = json
            .map((instruction) => Instruction.fromJson(instruction))
            .toList();

  List<dynamic> toJson() => instructions;
}
