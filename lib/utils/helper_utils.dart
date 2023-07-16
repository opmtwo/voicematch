String slugify(String text) {
  final pattern = RegExp(r'[^a-zA-Z0-9]+');
  final slug = text.toLowerCase().replaceAll(pattern, '-');
  return slug;
}

String enumToString(Enum e) {
  return e.toString().split('.').last;
}
