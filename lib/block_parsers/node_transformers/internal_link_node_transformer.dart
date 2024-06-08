import 'package:markdown/markdown.dart';

class LinkBlockTransformer extends BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^:::link\{(.+)\}$', multiLine: true);

  @override
  Node parse(BlockParser parser) {
    // Get the match from the current line
    Match match = pattern.firstMatch(parser.current.content) as Match;

    // Get the link from the match
    String? link = match.group(1);

    // Create the img element with the relative src
    final imgElement = Element('img', []);
    imgElement.attributes['src'] = 'https://api.iconify.design/fluent-emoji-flat/alarm-clock.svg';
    imgElement.attributes['alt'] = 'Link icon';
    imgElement.attributes['class'] = 'h-6 w-6';

    Element a = Element('a', [imgElement]);
    a.attributes['href'] = link ?? 'error';

    // Advance the block_parsers to the next line
    parser.advance();

    return a;
  }
}
