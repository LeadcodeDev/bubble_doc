import 'package:bubble_doc/block_parsers/node_transformers/codeblock/code_block_line_transformer.dart';

final class DeletesLineTransformer implements CodeBlockLineTransformer {
  @override
  final List<int> linesNumbers = [];

  @override
  String get start => '// delete-start';

  @override
  String get end => '// delete-end';

  @override
  bool isActive = false;

  @override
  bool match(line) => switch(line) {
    String value when value.contains(start) => true,
    String value when value.contains(end) => true,
    _ => isActive == true,
  };

  @override
  String? transform(int index, String line) {
    if (line.contains(start)) {
      isActive = true;
      return null;
    } else if (line.contains(end)) {
      isActive = false;
      return null;
    }

    if (isActive) {
      linesNumbers.add(index);
    }

    return line;
  }
}
