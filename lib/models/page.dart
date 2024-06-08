import 'package:bubble_doc/models/front_matter.dart';

final class Page {
  final String title;
  final String slug;
  final Future<(FrontMatter, String)> Function(Map<String, dynamic>) parse;
  final String location;

  Page({required this.title, required this.slug, required this.parse, required this.location});
}
