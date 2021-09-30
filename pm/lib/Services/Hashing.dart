import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class Hashing {
  static textToBytes(text) {
    return utf8.encode(text);
  }

  static sha1(text) {
    final bytes = textToBytes(text);
    return crypto.sha1.convert(bytes).toString();
  }

  static sha256(text) {
    final bytes = textToBytes(text);
    return crypto.sha256.convert(bytes).toString();
  }

  static md5(text) {
    final bytes = textToBytes(text);
    return crypto.md5.convert(bytes).toString();
  }
}
