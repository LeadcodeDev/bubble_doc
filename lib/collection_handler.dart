import 'dart:io';

import 'package:bubble_doc/models/page.dart';
import 'package:collection/collection.dart';
import 'package:jinja/jinja.dart';
import 'package:shelf/shelf.dart';

abstract interface class CollectionHandlerContract {
  Future<String?> handle(Request request, String path, {Map<String, dynamic> payload = const {}});
}

class CollectionHandler implements CollectionHandlerContract {
  late final Environment _environment;
  final File? layout;
  final List<Page> pages;

  CollectionHandler(
      {required Environment environment, this.pages = const [], required this.layout}) {
    _environment = environment;
  }

  @override
  Future<String?> handle(Request request, String path, {Map<String, dynamic> payload = const {}}) async {
    final Page? page = pages.firstWhereOrNull((Page page) => page.slug == path);

    if (page == null) {
      throw Exception('Page not found');
    }

    final (frontMatter, content) = await page.parse({'index': path});

    final layout = switch (this.layout) {
      File layout => await layout.readAsString(), _ => null
    };

    final fragment = _environment.fromString(content);

    if (layout != null) {
      final template = _environment.fromString(layout);
      return template.render({
        'title': frontMatter.variables['title'],
        ...payload,
        'content': fragment.render(payload),
      });
    }

    return fragment.render();
  }
}
