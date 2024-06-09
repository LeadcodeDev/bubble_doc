import 'dart:io';

import 'package:bubble_doc/models/front_matter.dart';
import 'package:bubble_doc/models/page.dart';
import 'package:jinja/jinja.dart';

final class CollectionBuilder {
  final Environment _environment;
  final File? _layout;
  final List<Page> _pages;
  final String _prefix;

  CollectionBuilder({
    required List<Page> pages,
    required layout,
    required Environment environment,
    required String prefix,
  })  : _pages = pages,
        _layout = layout,
        _environment = environment,
        _prefix = prefix;

  Future<void> build({Map<String, dynamic> defaultProps = const {}}) async {
    final distDirectory = Directory('${Directory.current.path}/dist/$_prefix');
    if (!distDirectory.existsSync()) {
      await distDirectory.create(recursive: true);
    }

    await Future.wait(_pages.map((page) async {
      final (frontMatter, content) = await page.parse({});

      final layout = switch (_layout) { File layout => await layout.readAsString(), _ => null };

      final fragment = _environment.fromString(content);

      if (layout != null) {
        final template = _environment.fromString(layout);
        final renderedPage = template.render({
          'css': (String path) => '<link rel="stylesheet" href="/$path">',
          'title': frontMatter.variables['title'],
          ...defaultProps,
          'content': fragment.render(defaultProps),
        });

        return writePage(frontMatter, renderedPage);
      }

      final renderedPage = fragment.render();
      return writePage(frontMatter, renderedPage);
    }));

    await copyAssets();
  }

  Future<File> writePage(FrontMatter frontMatter, String content) async {
    print('Writing page');
    final file = File('${Directory.current.path}/dist/$_prefix/${frontMatter.variables['slug']}.html');
    return file.writeAsString(content);
  }

  Future<void> copyAssets() async {
    final source = Directory('${Directory.current.path}/public');
    final destination = Directory('${Directory.current.path}/dist/public');

    if (!destination.existsSync()) {
      await destination.create(recursive: true);
    }

    walk(destination, source);
  }

  Future<void> walk(Directory destination, Directory directory) async {
    for (final element in directory.listSync()) {
      if (element is File) {
        element.copy('${destination.path}/${element.uri.pathSegments.last}');
      } else if (element is Directory) {
        final folderName = element.uri.pathSegments.elementAt(element.uri.pathSegments.length - 2);

        await Directory('${destination.path}/$folderName').create();
        await walk(Directory('${destination.path}/$folderName'), element);
      }
    }
  }
}
