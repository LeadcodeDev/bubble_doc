import 'package:markdown/markdown.dart';

class ParagraphBlockTransformer extends ParagraphSyntax {
  @override
  Node? parse(BlockParser parser) {
    final element = super.parse(parser) as Element?;
    return element?..attributes['class'] = 'py-2 font-light text-gray-900';
  }
}
