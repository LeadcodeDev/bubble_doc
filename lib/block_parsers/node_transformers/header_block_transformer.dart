import 'package:markdown/markdown.dart';

class HeaderBlockTransformer extends HeaderSyntax {
  @override
  Node parse(BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content)!;
    final openMarker = match[1]!;

    final element = super.parse(parser) as Element;
    final int level = openMarker.length;
    final String classes = switch(level) {
      int value when value == 1 => 'text-2xl font-medium tracking-tight text-gray-800 sm:text-5xl py-5',
      int value when value == 2 => 'text-2xl font-medium tracking-tight text-gray-800 sm:text-4xl pt-3',
      int value when value == 3 => 'text-xl font-medium tracking-tight text-gray-800 sm:text-3xl pt-3',
      int value when value == 4 => 'text-lg font-medium tracking-tight text-gray-800 sm:text-2xl pt-3',
      int value when value == 5 => 'text-base font-medium tracking-tight text-gray-800 sm:text-xl pt-3',
      int value when value == 6 => 'text-base font-medium tracking-tight text-gray-800 sm:text-lg pt-3',
      _ => 'text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl',
    };

    return element
      ..attributes['class'] = 'heading-${openMarker.length} mt-5 $classes'
      ..attributes['id'] = _normalize(element.textContent)
    ;
  }

  String _normalize(String value) {
    return value.toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(' ', '-');
  }
}
