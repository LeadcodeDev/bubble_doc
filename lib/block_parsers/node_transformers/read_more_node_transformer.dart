import 'package:markdown/markdown.dart';

class ReadMoreBlockTransformer extends BlockSyntax {
  @override
  RegExp get pattern =>
      RegExp(r'^:read-more\{to="(.+?)"(?:\s*title="([^"]*)")?\}$', multiLine: true);

  @override
  Node parse(BlockParser parser) {
    // Get the match from the current line
    Match match = pattern.firstMatch(parser.current.content) as Match;

    String? link = match.group(1);
    String? title = match.group(2);

    Element icon = Element.text('div', bookmarkIcon);
    icon.attributes['class'] = 'text-gray-700';

    Element targetIcon =
        Element.text('div', readMoreIcon);
    icon.attributes['class'] = 'text-gray-700';

    final sentence = Element('span', [
      if (title != null)
        Element.text('span', 'Read more in ')..attributes['class'] = 'text-gray-700',
      if (title != null) Element.text('span', title)..attributes['class'] = 'font-semibold',
      if (title == null) Element.text('span', 'Read more')..attributes['class'] = 'text-gray-700',
    ]);

    final container = Element('span', [icon, sentence])
      ..attributes['class'] = 'inline-flex w-full items-center gap-x-3';

    final element = Element('a', [container, if (link!.startsWith('http')) targetIcon]);

    element.attributes['class'] =
        'inline-flex w-full justify-between items-center border border-dashed border-gray-300 bg-gray-50 text-gray-900 px-5 py-4 my-2 rounded-lg';
    element.attributes['href'] = link;

    if (link.startsWith('http')) {
      element.attributes['target'] = '_blank';
      element.attributes['rel'] = 'noopener noreferrer';
    }

    // Advance the block_parsers to the next line
    parser.advance();

    return element;
  }
}

final bookmarkIcon = '''
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="w-4 h-4">
  <g fill="none" stroke="currentColor" stroke-width="1.5">
    <path
        d="M21 16.09v-4.992c0-4.29 0-6.433-1.318-7.766C18.364 2 16.242 2 12 2C7.757 2 5.636 2 4.318 3.332C3 4.665 3 6.81 3 11.098v4.993c0 3.096 0 4.645.734 5.321c.35.323.792.526 1.263.58c.987.113 2.14-.907 4.445-2.946c1.02-.901 1.529-1.352 2.118-1.47c.29-.06.59-.06.88 0c.59.118 1.099.569 2.118 1.47c2.305 2.039 3.458 3.059 4.445 2.945c.47-.053.913-.256 1.263-.579c.734-.676.734-2.224.734-5.321Z"/>
    <path stroke-linecap="round" d="M15 6H9"/>
  </g>
</svg>
''';

final readMoreIcon = '''
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="w-4 h-4">
  <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-width="1.5">
    <path
        d="M22 12c0 4.714 0 7.071-1.465 8.535C19.178 21.894 17.055 21.993 13 22M2 11c.008-4.055.107-6.178 1.464-7.536C4.93 2 7.286 2 12 2c4.714 0 7.071 0 8.535 1.464c.974.974 1.3 2.343 1.41 4.536"/>
    <path stroke-linejoin="round" d="m3 21l8-8m0 0H5m6 0v6"/>
  </g>
</svg>
''';
