import 'package:encrypt/encrypt.dart';

class Encryption {
  static final iv = IV.fromLength(16);

  static generateEncrypter(key) {
    return Encrypter(AES(Key.fromUtf8(key)));
  }

  static enc(text, key) {
    Encrypter encrypter = generateEncrypter(key);
    return encrypter.encrypt(text, iv: iv).base64.toString();
  }

  static dec(text, key) {
    Encrypter encrypter = generateEncrypter(key);
    return encrypter.decrypt(Encrypted.from64(text), iv: iv).toString();
  }
}
