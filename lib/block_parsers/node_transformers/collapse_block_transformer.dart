import 'package:markdown/markdown.dart';

class CollapseBlockTransformer extends BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^::collapse((?:\n:::item\{title="[^"]*"\}\n(?:.|\n)*?\n:::)*\n):::', multiLine: true, dotAll: true);
  @override
  Node parse(BlockParser parser) {
    Match match = pattern.firstMatch(parser.current.content) as Match;

    parser.advance();

    String content = match.group(1) ?? '';

    return Element('div', [Text(content)]);
  }
}

class ItemBlockTransformer extends BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^:::item\{title="([^"]*)"\}\s*((?:.|\n)*?)\s*:::', multiLine: true, dotAll: true);

  @override
  Node parse(BlockParser parser) {
    Match match = pattern.firstMatch(parser.current.content) as Match;

    parser.advance();

    String title = match.group(1) ?? '';
    String content = match.group(2) ?? '';

    return Element('div', [Text(title), Text(content)]);
  }
}
