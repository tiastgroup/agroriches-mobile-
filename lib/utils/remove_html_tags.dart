String stripHtmlTags(text) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return text.replaceAll(exp, '');
}
