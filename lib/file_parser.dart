import 'dart:io';

import 'package:bubble_doc/block_parsers/content_transformer.dart';
import 'package:bubble_doc/front_matter_parser.dart';
import 'package:bubble_doc/models/page.dart';

final class FileParser {
  final FrontMatterParser _frontMatterParser = FrontMatterParser();
  final ContentTransformer transformer;

  FileParser({required this.transformer});

  Page parse(File file, {Map<String, dynamic> payload = const {}}) {
    final content = file.readAsStringSync();
    final frontMatter = _frontMatterParser.parse(content);

    return Page(
      title: frontMatter.variables['title'],
      slug: frontMatter.variables['slug'],
      location: file.path,
      parse: (Map<String, dynamic> payload) async {
        final content = file.readAsStringSync();
        final frontMatter = _frontMatterParser.parse(content);
        final String transformedContent = transformer.transform(frontMatter.size, content, payload);
        return (frontMatter, transformedContent);
      },
    );
  }
}
