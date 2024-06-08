abstract interface class CodeBlockLineTransformer {
  List<int> get linesNumbers;
  String get start;
  String get end;
  abstract bool isActive;
  bool match(line);
  String? transform(int index, String line);
}
