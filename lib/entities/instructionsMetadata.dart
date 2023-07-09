import 'instructionMetadata.dart';

class InstructionsMetadata {
  final List<InstructionMetadata> instructionsMetadata;

  InstructionsMetadata(this.instructionsMetadata);

  InstructionsMetadata.fromJson(List<dynamic> json)
      : instructionsMetadata = json
            .map((instructionMetadata) =>
                InstructionMetadata.fromJson(instructionMetadata))
            .toList();

  List<dynamic> toJson() => instructionsMetadata;
}
