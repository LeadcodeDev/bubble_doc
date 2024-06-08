import 'dart:io';

import 'package:bubble_doc/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

void main(List<String> args) async {
  final docs = Collection(
    match: '/docs/<ignored|.*>',
    source: Directory('${Directory.current.path}/content/docs'),
    templates: Directory('${Directory.current.path}/template'),
    layout: File('pages/docs.html'),
    globals: {
      'links': [
        {'label': 'Documentation', 'to': '/docs'},
        {'label': 'GitHub', 'to': ''},
      ]
    },
  );

  final Router router = Router()
    ..get(docs.match, docs.handle)
    ..get('/<ignored|.*>', createStaticHandler('public'));

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '4444');
  final server = await serve(handler, InternetAddress.anyIPv4, port);

  print('Server listening on port ${server.port}');
}
