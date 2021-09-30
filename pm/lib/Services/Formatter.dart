class Formatter {
  static String addSIfMoreThenOne(String text, int count) {
    if (count > 1)
      return text + 's';
    else
      return text;
  }

  static String toUppercaseFirstChar(String text) {
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  static String websiteListTile(String text) {
    String _text = text.substring(text.indexOf('.') + 1);
    _text = toUppercaseFirstChar(_text);
    return _text;
  }

  static String websiteHeader(String text) {
    String _website = text.split('.')[1];
    _website = toUppercaseFirstChar(_website);
    return _website;
  }

  static String numberWithName(String name, int number) {
    return '$number ${Formatter.addSIfMoreThenOne(name, number)}';
  }
}
