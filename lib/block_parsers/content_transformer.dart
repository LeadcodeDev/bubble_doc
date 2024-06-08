abstract interface class ContentTransformer {
  String transform(int frontMatterSize, String content, Map<String, dynamic> payload);
}
