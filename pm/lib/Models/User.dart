import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pm/Models/models.dart';
import 'package:pm/Services/services.dart';

class User extends ChangeNotifier {
  int? id;
  int notificationFreq = -1;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? hint;
  String? salt;
  String? serialNumber;
  String? firebaseToken;
  List<Map<String, dynamic>>? accountsJson;
  late String key;
  late List<Account> accounts;

  void setId(int? id) {
    this.id = id;
  }

  String hashPassword() {
    return Hashing.sha256(this.salt! + this.password!);
  }

  void generateKeyFromPassword(String password) {
    this.key = Hashing.md5(password);
  }

  String convertPasswordToSha1() {
    String _sha1 = Hashing.sha1(password);
    _sha1 = _sha1.substring(0, 5) + '-' + _sha1.substring(_sha1.length - 5);
    return _sha1;
  }

  int convertNotificationFreqIndexToNumberOfMonths(int index) {
    if (index == 0) {
      return 24;
    } else if (index == 1) {
      return 12;
    } else if (index == 2) {
      return 6;
    } else if (index == 3) {
      return 3;
    } else if (index == 4) {
      return 1;
    } else {
      return 0;
    }
  }

  int convertNotificationFreqNumberOfMonthsToIndex(int? numberOfMonths) {
    if (numberOfMonths == 24) {
      return 0;
    } else if (numberOfMonths == 12) {
      return 1;
    } else if (numberOfMonths == 6) {
      return 2;
    } else if (numberOfMonths == 3) {
      return 3;
    } else if (numberOfMonths == 1) {
      return 4;
    } else {
      return 5;
    }
  }

  List<String?> getWebsitesNames() {
    List<String?> websites = [];
    Map<String?, List<Account>> accountsMap = getAccountsMap();
    accountsMap.forEach((key, value) => websites.add(key));
    return websites;
  }

  Map<String, dynamic> toJsonForSignUp() {
    return {
      'username': this.username,
      'email': this.email,
      'password': this.hashPassword(),
      'hashPassword': this.convertPasswordToSha1(),
      'salt': this.salt,
      'phoneNumber': this.phone,
      'hint': this.hint,
      'serialNumber': this.serialNumber,
      'deviceId': this.firebaseToken
    };
  }

  Map<String, dynamic> toJsonForSignIn() {
    return {
      'username': this.username,
      'password': this.hashPassword(),
      'serialNumber': this.serialNumber,
      'deviceId': this.firebaseToken
    };
  }

  Map<String?, List<Account>> getAccountsMap() {
    Map<String?, List<Account>> map = Map();
    for (Account account in accounts) {
      if (!map.containsKey(account.website)) {
        map[account.website] = [];
      }
      map[account.website]!.add(account);
    }
    return map;
  }

  List<Account> getAccountsByWebsite(website) {
    return getAccountsMap()[website] ?? [];
  }

  int numberOfWarningsInWebsite(String? website) {
    List<Account> websiteAccounts = getAccountsByWebsite(website);
    int numberOfWarnings = 0;
    for (Account account in websiteAccounts) {
      if (account.isCompPassword == 1) {
        numberOfWarnings++;
      }
    }
    return numberOfWarnings;
  }

  Account getAccountById(id) {
    for (var account in accounts) {
      if (account.id == id) {
        return account;
      }
    }
    return Account();
  }

  int getAccountIndexById(id) {
    for (var i = 0; i < accounts.length; i++) {
      if (accounts[i].id == id) {
        return i;
      }
    }
    assert(false);
    return -1;
  }

  bool isNewAccount(String? website, String? email) {
    for (Account account in accounts) {
      if (account.website == website && account.email == email) {
        return false;
      }
    }
    return true;
  }

  int repeatedPassword(String password) {
    int count = 0;
    for (Account account in accounts) {
      count += (account.password == password ? 1 : 0);
    }
    return count;
  }

  bool isWeakPassword(String password) {
    if (password.length < 8) return true;
    final specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    int strength = 0;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(specialChars)) strength++;
    return strength < 3;
  }

  void fromJson(Map<String, dynamic> user) {
    this.id = user['id'];
    this.username = user['username'];
    this.email = user['email'];
    this.phone = user['phone'];
    this.password = user['password'];
    this.hint = user['hint'];
  }

  Future setSerialNumber() async {
    String identifier = '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    this.serialNumber = identifier;
  }

  void fillInfo(String username, String email, String phone) {
    this.username = username;
    this.email = email;
    this.phone = phone;
    this.salt = Hashing.md5(username).substring(0, 16);
  }

  void fillPassword(String password, String hint) {
    this.password = password;
    this.hint = hint;
  }

  void fillSignInInfo(String username, String password) {
    this.username = username;
    this.password = password;
    generateKeyFromPassword(password);
    this.salt = Hashing.md5(username).substring(0, 16);
  }
}
