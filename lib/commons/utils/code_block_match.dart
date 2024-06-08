import 'dart:convert';

final class CodeBlockMatch {
  CodeBlockMatch._({
    required this.indent,
    required this.marker,
    required this.info,
  });

  factory CodeBlockMatch.fromMatch(RegExpMatch match, List<String> fenceMarkers) {
    String? marker;
    String? info;

    for (final fenceMarker in fenceMarkers) {
      if (match.namedGroup(fenceMarker) != null) {
        marker = fenceMarker;
        info = match.namedGroup('${fenceMarker}Info')!;
        break;
      }
    }

    if (marker == null || info == null) {
      marker = match.namedGroup('tilde')!;
      info = match.namedGroup('tildeInfo')!;
    }

    return CodeBlockMatch._(
      indent: match[1]!.length,
      marker: marker,
      info: info.trim(),
    );
  }

  final int indent;
  final String marker;

// The info-string should be trimmed,
// https://spec.commonmark.org/0.30/#info-string.
  final String info;

// The first word of the info string is typically used to specify the language
// of the code sample,
// https://spec.commonmark.org/0.30/#example-143.
  String get language => info.split(' ').first;

  bool get hasInfo => info.isNotEmpty;

  bool get hasLanguage => language.isNotEmpty;
}

String escapePunctuation(String input) {
  const int backslash = 0x5C;
  const asciiPunctuationCharacters = r'''!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''';
  final buffer = StringBuffer();

  for (var i = 0; i < input.length; i++) {
    if (input.codeUnitAt(i) == backslash) {
      final next = i + 1 < input.length ? input[i + 1] : null;
      if (next != null && asciiPunctuationCharacters.contains(next)) {
        i++;
      }
    }
    buffer.write(input[i]);
  }

  return buffer.toString();
}

String escapeHtml(String html, {bool escapeApos = true}) => HtmlEscape(HtmlEscapeMode(
      escapeApos: escapeApos,
      escapeLtGt: true,
      escapeQuot: true,
    )).convert(html);

String escapeHtmlAttribute(String text) => const HtmlEscape(HtmlEscapeMode.attribute).convert(text);
