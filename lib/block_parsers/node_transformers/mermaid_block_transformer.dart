import 'package:bubble_doc/commons/utils/code_block_match.dart';
import 'package:markdown/markdown.dart';

class MermaidBlockTransformer extends BlockSyntax {
  @override
  RegExp get pattern => RegExp(
        '^([ ]{0,3})(?:(?<backtick>`{3,})(?<backtickInfo>[^`]*)|'
        r'(?<tilde>~{3,})(?<tildeInfo>.*))$',
      );

  @override
  Node? parse(BlockParser parser) {
    final openingFence = CodeBlockMatch.fromMatch(pattern.firstMatch(
      escapePunctuation(parser.current.content),
    )!, ['tilde', 'backtick']);

    if (openingFence.hasLanguage && openingFence.language != 'mermaid') {
      return null;
    }

    var text = parseChildLines(
      parser,
      openingFence.marker,
      openingFence.indent,
    ).map((e) => e.content).join('\n');

    if (parser.document.encodeHtml) {
      text = escapeHtml(text, escapeApos: false);
    }
    if (text.isNotEmpty) {
      text = '$text\n';
    }

    return Element('pre', [Text(text)])..attributes['class'] = 'mermaid';
  }

  String _removeIndentation(String content, int length) {
    final text = content.replaceFirst(RegExp('^\\s{0,$length}'), '');
    return content.substring(content.length - text.length);
  }

  @override
  List<Line> parseChildLines(
    BlockParser parser, [
    String openingMarker = '',
    int indent = 0,
  ]) {
    final childLines = <Line>[];

    parser.advance();

    CodeBlockMatch? closingFence;
    while (!parser.isDone) {
      final match = pattern.firstMatch(parser.current.content);
      closingFence = match == null ? null : CodeBlockMatch.fromMatch(match, ['tilde', 'backtick']);

      if (closingFence == null ||
          !closingFence.marker.startsWith(openingMarker) ||
          closingFence.hasInfo) {
        childLines.add(
          Line(_removeIndentation(parser.current.content, indent)),
        );
        parser.advance();
      } else {
        parser.advance();
        break;
      }
    }

    if (closingFence == null && childLines.isNotEmpty && childLines.last.isBlankLine) {
      childLines.removeLast();
    }

    return childLines;
  }
}
