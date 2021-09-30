import 'package:pm/Models/models.dart';
import 'package:pm/Services/services.dart';

class CSV {
  final String? name;
  final List<List<dynamic>>? fields;
  int? websiteIndex, emailIndex, passwordIndex;

  CSV(this.name, this.fields);

  void setWebsiteIndex(int index) {
    this.websiteIndex = index;
  }

  void setEmailIndex(int index) {
    this.emailIndex = index;
  }

  void setPasswordIndex(int index) {
    this.passwordIndex = index;
  }

  int numberOfRecords() {
    return fields!.length;
  }

  int numberOfFields() {
    if (fields!.length == 0) return 0;
    return fields![0].length;
  }

  Account fieldToAccount(field) {
    return Account(
      website: field[websiteIndex].toString(),
      email: field[emailIndex].toString(),
      password: field[passwordIndex].toString(),
      date: DateController.getDate(),
    );
  }

  List<Account> toAccounts() {
    List<Account> accounts = [];
    for (int i = 1; i < fields!.length; i++) {
      accounts.add(fieldToAccount(fields![i]));
    }
    return accounts;
  }
}
