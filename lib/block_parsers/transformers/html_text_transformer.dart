import 'package:bubble_doc/block_parsers/content_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/callout_block_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/code_block_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/header_block_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/mermaid_block_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/paragraph_block_transformer.dart';
import 'package:bubble_doc/block_parsers/node_transformers/read_more_node_transformer.dart';
import 'package:markdown/markdown.dart';

import 'plain_text_transformer.dart';

final class HtmlTextTransformer implements ContentTransformer {
  late final List<BlockSyntax> blocks;

  HtmlTextTransformer({List<BlockSyntax>? blocks}) {
    this.blocks = blocks ?? [
      MermaidBlockTransformer(),
      CalloutBlockTransformer(),
      CodeBlockTransformer(),
      HeaderBlockTransformer(),
      UnorderedListSyntax(),
      OrderedListSyntax(),
      UnorderedListWithCheckboxSyntax(),
      ReadMoreBlockTransformer(),
      HorizontalRuleSyntax(),
      ParagraphBlockTransformer(),
      TableSyntax(),
      HeaderWithIdSyntax(),
    ];
  }

  @override
  String transform(int frontMatterSize, String content, Map<String, dynamic> payload) {
    final plainTextContent = PlainTextTransformer().transform(frontMatterSize, content, payload);
    return markdownToHtml(plainTextContent, extensionSet: ExtensionSet.none, blockSyntaxes: blocks);
  }
}
