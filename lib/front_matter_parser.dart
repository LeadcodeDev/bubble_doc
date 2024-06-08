import 'package:bubble_doc/models/front_matter.dart';

final class FrontMatterParser {
  final String separator;

  FrontMatterParser({this.separator = '---'});

  String _extractFrontMatterSegment(String content) {
    final value = content.trimLeft();
    if (!value.startsWith(separator)) {
      throw Exception('Invalid front matter');
    }

    return value.substring(separator.length, value.indexOf('\n$separator')).trim();
  }

  int getFrontMatterSize(String content) {
    final value = content.trimLeft();
    if (!value.startsWith(separator)) {
      throw Exception('Invalid front matter');
    }

    return value.indexOf('\n$separator') + 4;
  }

  List<String> _getArgs(String content) {
    final String frontMatter = _extractFrontMatterSegment(content);
    return frontMatter
        .split('\n')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  T build<T>(
      {required String content,
        T Function(Map<String, String>)? builder,
        Map<String, dynamic>? payload}) {
    return builder!(_parseToMap(content, payload));
  }

  Map<String, String> _parseToMap(String content, Map<String, dynamic>? payload) {
    return _getArgs(content).fold({}, (acc, arg) {
      final [key, value] = arg.split(':');
      if (payload == null) {
        return {...acc, key: value.trim()};
      }

      final newValue = payload.entries.fold(
          value.trim(), (acc, entry) => acc.replaceAll('{${entry.key}}', entry.value.toString()));
      return {...acc, key: newValue};
    });
  }

  FrontMatter parse(String content, {Map<String, dynamic>? payload}) {
    final size = getFrontMatterSize(content);
    final variables = _parseToMap(content, payload);

    return FrontMatter(size, variables, separator);
  }
}
