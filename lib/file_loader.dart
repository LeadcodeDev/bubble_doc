import 'dart:io';

final class FileLoader {
  final List<File> files = [];

  void load(Directory source) {
    _walk(source);
  }

  void _walk(Directory directory) {
    for (final FileSystemEntity entity in directory.listSync()) {
      if (entity is File) {
        final File file = File(entity.path);
        files.add(file);
      } else if (entity is Directory) {
        _walk(entity);
      }
    }
  }
}
