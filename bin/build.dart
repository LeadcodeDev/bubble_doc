import 'dart:io';

import 'package:bubble_doc/collection.dart';

void main(List<String> args) async {
  final global = {
    'links': [
      {'label': 'Documentation', 'to': '/docs'},
      {'label': 'GitHub', 'to': ''},
    ]
  };

  final docs = Collection(
    match: '/docs/<ignored|.*>',
    prefix: 'docs',
    source: Directory('${Directory.current.path}/content'),
    templates: Directory('${Directory.current.path}/template'),
    layout: File('pages/docs.html'),
    globals: global
  );

  await docs.build();
}
