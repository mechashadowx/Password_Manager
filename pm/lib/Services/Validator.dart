class Validator {
  static const nullDialingCode = '(+000)';
  static const emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const websitePattern = r'^[a-zA-Z]+\.[a-zA-Z]+\.[a-zA-Z]+';
  static const phonePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  static isUsername(String text) {
    return text.length > 0;
  }

  static isEmail(String text) {
    if (text.length == 0) return false;
    if (text[text.length - 1] == ' ') return false;
    return RegExp(emailPattern).hasMatch(text);
  }

  static isWebsite(String text) {
    if (text.length == 0) return false;
    if (text[text.length - 1] == ' ') return false;
    return RegExp(websitePattern).hasMatch(text);
  }

  static isPhone(text, String code) {
    if (code == nullDialingCode) return false;
    return RegExp(phonePattern).hasMatch(text);
  }

  static isPassword(String text) {
    return text.length > 11;
  }

  static isHint(String text) {
    return text.length > 0;
  }
}
