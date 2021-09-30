import 'dart:math';

class PasswordGenerator {
  static const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  static const upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const numbers = '0123456789';
  static const special = '@#=+!£\$%&?[](){}';

  static getRandomIndex(int length) {
    return Random.secure().nextInt(length);
  }

  static getAllowedChars() {
    return lowerCaseLetters + upperCaseLetters + numbers + special;
  }

  static getRandomChar() {
    var allowedChars = getAllowedChars();
    var randomChar = allowedChars[getRandomIndex(allowedChars.length)];
    return randomChar;
  }

  static generate({int length = 15}) {
    var password = '';
    for (int i = 0; i < length; i++) {
      password += getRandomChar();
    }
    return password;
  }
}
