import 'dart:convert';

import 'package:bubble_doc/block_parsers/node_transformers/codeblock/code_block_line_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/codeblock/deletes_line_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/codeblock/highlight_line_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/codeblock/inserts_line_transformer.dart';
import 'package:bubble_doc/commons/utils/code_block_match.dart';
import 'package:collection/collection.dart';
import 'package:markdown/markdown.dart';

class CodeBlockTransformer extends FencedCodeBlockSyntax {
  @override
  Node parse(BlockParser parser) {
    final openingFence = CodeBlockMatch.fromMatch(pattern.firstMatch(
      escapePunctuation(parser.current.content),
    )!, ['tilde', 'backtick']);

    final highlightLineTransformer = HighlightLineTransformer();
    final insertsLineTransformer = InsertsLineTransformer();
    final deletesLineTransformer = DeletesLineTransformer();

    final List<CodeBlockLineTransformer> transformers = [
      highlightLineTransformer,
      insertsLineTransformer,
      deletesLineTransformer,
    ];

    final buffer = StringBuffer();
    final lines = parseChildLines(parser);

    int ignoreLines = 0;
    for (final line in lines) {
      final index = lines.indexOf(line);

      final transformer =
          transformers.firstWhereOrNull((transformer) => transformer.match(line.content));
      if (transformer != null) {
        if ([transformer.start, transformer.end].contains(line.content.trim())) {
          ignoreLines += 1;
        }

        final content = transformer.transform(index - ignoreLines + 1, line.content);
        if (content != null) {
          buffer.writeln(content);
        }
      } else {
        buffer.writeln(line.content);
      }
    }

    final code = htmlEscape.convert(buffer.toString());
    final meta = jsonEncode({
      'highlight': highlightLineTransformer.linesNumbers,
      'insertLines': insertsLineTransformer.linesNumbers,
      'removeLines': deletesLineTransformer.linesNumbers,
    });

    return Text('<pre class="$code" data-lang="${openingFence.language}" data-meta="$meta">{{content}}</pre>');
  }
}
