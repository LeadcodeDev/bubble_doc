import 'package:bubble_doc/block_parsers/content_transformer.dart';

final class PlainTextTransformer implements ContentTransformer {

  @override
  String transform(int frontMatterSize, String content, Map<String, dynamic> payload) {
    final md = content.substring(frontMatterSize).trim();

    return payload.entries
        .fold(md.trim(), (acc, entry) => acc.replaceAll('{${entry.key}}', entry.value.toString()));
  }
}
