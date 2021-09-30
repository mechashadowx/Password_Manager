import 'package:pm/Services/services.dart';

class Account {
  int? id;
  String? website;
  String? email;
  String? password;
  String? date;
  int? isCompPassword;

  Account({
    this.id,
    this.website = '',
    this.email = '',
    this.password = '',
    this.date = '',
    this.isCompPassword = 0,
  });

  convertPasswordToSha1() {
    String _sha1 = Hashing.sha1(password);
    _sha1 = _sha1.substring(0, 5) + '-' + _sha1.substring(_sha1.length - 5);
    return _sha1;
  }

  setDate() {
    this.date = DateController.getDate();
  }

  String dateFormat(String date) {
    List<String> yymmdd = date.split('-');
    String year = yymmdd[0];
    String month = yymmdd[1];
    String day = yymmdd[2];
    return '$day-$month-$year';
  }

  Account.fromJson(Map<String, dynamic> json, String key) {
    id = json['id'];
    website = Encryption.dec(json['website'], key);
    email = Encryption.dec(json['email'], key);
    password = Encryption.dec(json['password'], key);
    date = dateFormat(json['date']);
    isCompPassword = json['isPassCom'] ?? 0;
  }

  Map<String, dynamic> toJson(String key) {
    return {
      'website': Encryption.enc(this.website, key),
      'email': Encryption.enc(this.email, key),
      'password': Encryption.enc(this.password, key),
      'hashPassword': convertPasswordToSha1()
    };
  }

  Map<String, dynamic> toJsonForNewPassword(String key) {
    return {
      'id': this.id,
      'website': Encryption.enc(this.website, key),
      'email': Encryption.enc(this.email, key),
      'password': Encryption.enc(this.password, key),
      'hashPassword': convertPasswordToSha1(),
      'date': this.date
    };
  }

  Account.copyAccount(Account account) {
    this.id = account.id;
    this.website = account.website;
    this.email = account.email;
    this.password = account.password;
    this.date = account.date;
    this.isCompPassword = account.isCompPassword;
  }
}
