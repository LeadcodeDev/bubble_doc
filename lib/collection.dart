import 'dart:io';

import 'package:bubble_doc/block_parsers/transformers/html_text_transformer.dart';
import 'package:bubble_doc/collection_builder.dart';
import 'package:bubble_doc/collection_handler.dart';
import 'package:bubble_doc/block_parsers/content_transformer.dart';
import 'package:bubble_doc/file_loader.dart';
import 'package:bubble_doc/file_parser.dart';
import 'package:bubble_doc/models/page.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';
import 'package:markdown/markdown.dart';
import 'package:shelf/shelf.dart';

final class Collection {
  final FileLoader _fileLoader = FileLoader();

  late final FileParser _fileParser;
  late final CollectionBuilder _collectionBuilder;

  final Map<String, dynamic> globals;
  final List<Page> pages = [];

  late final CollectionHandler _collectionHandler;

  final String match;
  final String prefix;
  final Directory source;
  final File? layout;

  /// The root template directory.
  /// The values in this list are the directories where the template are located.
  /// The directories are relative to the [Directory] of the project.
  final Directory templates;

  final List<BlockSyntax> blockSyntax = [];

  Collection(
      {required this.match,
      required this.prefix,
      required this.source,
      required this.templates,
      this.layout,
      this.globals = const {},
      ContentTransformer? transformer,
        List<BlockSyntax> blocks = const []
      }) {
    _fileParser = FileParser(transformer: transformer ?? HtmlTextTransformer());
    _fileLoader.load(Directory('${source.path}/$prefix'));

    blockSyntax.addAll(blocks);

    for (final file in _fileLoader.files) {
      final page = _fileParser.parse(file);
      pages.add(page);
    }

    final environment = Environment(
      autoReload: true,
      leftStripBlocks: true,
      globals: globals,
      loader: FileSystemLoader(paths: [templates.path]),
    );
    _collectionHandler = CollectionHandler(
        pages: pages,
        layout: File('${templates.path}/${layout?.path}'),
        environment: environment,
    );

    _collectionBuilder = CollectionBuilder(
      pages: pages,
      layout: File('${templates.path}/${layout?.path}'),
      environment: environment,
      prefix: prefix,
    );
  }

  Future<Response> handle(Request request, String path) async {
    try {
      final content = await _collectionHandler.handle(request, path);
      return Response.ok(content, headers: {'Content-Type': 'text/html'});
    } catch (e) {
      return Response.notFound(e.toString());
    }
  }

  Future<void> build() async {
    await _collectionBuilder.build();
  }
}
