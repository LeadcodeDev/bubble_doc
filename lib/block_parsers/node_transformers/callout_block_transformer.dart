import 'package:bubble_doc/commons/utils/code_block_match.dart';
import 'package:markdown/markdown.dart';

class CalloutBlockTransformer extends BlockSyntax {
  final String characterDelimiter = '::';

  @override
  RegExp get pattern =>
      RegExp('^([ ]{0,2})(?<fence>:{2,})(?<fenceInfo>[^:]*)({(?<parameters>.*)})\$');

  @override
  Node? parse(BlockParser parser) {
    final openingFence = CodeBlockMatch.fromMatch(
        pattern.firstMatch(
          escapePunctuation(parser.current.content),
        )!,
        ['fence']);

    final match = pattern.firstMatch(parser.current.content);
    final matchedParameters = match?.namedGroup('parameters');

    final RegExp titlePattern = RegExp(
      "\\s*title=\"(?<title>[^\"]*)\"",
      multiLine: true,
      dotAll: true,
    );

    final RegExp typePattern = RegExp(
      "\\s*type=\"(?<type>[^\"]*)\"",
      multiLine: true,
      dotAll: true,
    );

    final titleMatch = titlePattern.firstMatch(matchedParameters ?? '');
    final typeMatch = typePattern.firstMatch(matchedParameters ?? '');

    final title = titleMatch?.namedGroup('title');
    final type = typeMatch?.namedGroup('type');

    List<Line> lines = parseChildLines(
      parser,
      openingFence.marker,
      openingFence.indent,
    );

    final tempParser = BlockParser(lines, parser.document);
    final blockParsers = parser.blockSyntaxes.where((element) => element.canParse(tempParser));

    for (final blockParser in blockParsers) {
      final element = blockParser.parse(tempParser);
      if (element is Element) {
        final attributes = element.attributes.entries.map((e) => '${e.key}="${e.value}"').join(' ');
        final content = "<${element.tag} $attributes>${element.textContent}</${element.tag}>";

        return Element('div', [Text(createCalloutBlock(type, content, title))]);
      }
    }

    String a = lines.map((e) => e.content).join('\n');

    if (parser.document.encodeHtml) {
      a = escapeHtml(a, escapeApos: false);
    }
    if (a.isNotEmpty) {
      a = '$a\n';
    }

    return Element('div', [Text(createCalloutBlock(type, a, title))]);
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

    while (!parser.isDone) {
      final match = parser.current.content.startsWith(characterDelimiter);

      if (!match) {
        childLines.add(
          Line(_removeIndentation(parser.current.content, indent)),
        );

        parser.advance();
      } else {
        parser.advance();
        break;
      }
    }

    if (childLines.isNotEmpty && childLines.last.isBlankLine) {
      childLines.removeLast();
    }

    return childLines;
  }
}

String createCalloutBlock(String? type, String content, String? title) {
  final String containerClass = switch (type) {
    String type when type == 'warning' =>
      'bg-yellow-50 border-yellow-200 hover:border-yellow-300 text-yellow-900',
    String type when type == 'error' =>
      'bg-red-50 border-red-200 hover:border-red-300 text-red-900',
    _ =>
      'border-blue-200 bg-blue-50 bg-blue-50 border-blue-200 hover:border-blue-300 text-blue-900',
  };

  final String icon = switch (type) {
    _ => '''
    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="self-start w-6 h-6 text-blue-700">
    <g fill="none">
      <path stroke="currentColor" stroke-linecap="round" stroke-width="1.5" d="M12 7v6"/>
      <circle cx="12" cy="16" r="1" fill="currentColor"/>
      <path stroke="currentColor" stroke-linecap="round" stroke-width="1.5"
            d="M7 3.338A9.954 9.954 0 0 1 12 2c5.523 0 10 4.477 10 10s-4.477 10-10 10S2 17.523 2 12c0-1.821.487-3.53 1.338-5"/>
    </g>
  </svg>
  '''
  };

  return '''
  <div
    class="$containerClass inline-flex w-full items-center gap-x-3 border border-dashed hover:border-solid px-5 py-4 my-2 rounded-lg">
  <div class="py-2">
    $icon
  </div>
  <div class="flex-1">
    ${title != null ? '<p class="font-semibold">$title</p>' : ''}
    $content
  </div>
</div>
''';
}

final infoNoteIcon = '''
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="self-start w-6 h-6 text-blue-700">
    <g fill="none">
      <path stroke="currentColor" stroke-linecap="round" stroke-width="1.5" d="M12 7v6"/>
      <circle cx="12" cy="16" r="1" fill="currentColor"/>
      <path stroke="currentColor" stroke-linecap="round" stroke-width="1.5"
            d="M7 3.338A9.954 9.954 0 0 1 12 2c5.523 0 10 4.477 10 10s-4.477 10-10 10S2 17.523 2 12c0-1.821.487-3.53 1.338-5"/>
    </g>
  </svg>
  ''';

final errorIcon = '''
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="w-6 h-6 text-red-700">
    <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-width="1.5"
          d="m14.5 9.5l-5 5m0-5l5 5M7 3.338A9.954 9.954 0 0 1 12 2c5.523 0 10 4.477 10 10s-4.477 10-10 10S2 17.523 2 12c0-1.821.487-3.53 1.338-5"/>
  </svg>
  ''';

