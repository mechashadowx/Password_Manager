import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Models/models.dart';
import 'package:pm/Services/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class UploadCSV extends StatefulWidget {
  static final String id = 'Upload CSV';

  @override
  _UploadCSVState createState() => _UploadCSVState();
}

class _UploadCSVState extends State<UploadCSV> {
  CSV? csv;
  late CurrentUser user;
  int numberOfFields = 0;
  int numberOfAccounts = 0;
  int numberOfAddedAccounts = 0;
  bool isLoading = false, finished = false;
  int website = -1, email = -1, password = -1;

  String? subHeader =
      'You can upload a CSV file and add all your passwords quickly.';

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
  }

  void turnLoadingOn() {
    setState(() {
      isLoading = true;
    });
  }

  void turnLoadingOff() {
    setState(() {
      isLoading = false;
    });
  }

  void delete() {
    setState(() {
      csv = null;
      email = -1;
      website = -1;
      password = -1;
      finished = false;
      numberOfAddedAccounts = 0;
    });
  }

  bool checkEverythingSelected() {
    if (website == -1) {
      Toast.showInfo(context, 'Website not found');
    } else if (email == -1) {
      Toast.showInfo(context, 'Email not found');
    } else if (password == -1) {
      Toast.showInfo(context, 'Password not found');
    } else {
      return true;
    }
    return false;
  }

  void setCsvFields() {
    csv!.setWebsiteIndex(website);
    csv!.setEmailIndex(email);
    csv!.setPasswordIndex(password);
  }

  Future addAccountsFromCsv() async {
    List<Account> accounts = csv!.toAccounts();
    for (Account account in accounts) {
      if (!user.isNewAccount(account.website, account.email)) {
        continue;
      }
      bool success = await user.addAccount(account);
      if (success) {
        setState(() {
          numberOfAddedAccounts++;
        });
      }
    }
    setState(() {
      finished = true;
    });
    Toast.showDone(context);
  }

  void save() async {
    if (!checkEverythingSelected()) return;
    turnLoadingOn();
    setCsvFields();
    await addAccountsFromCsv();
    turnLoadingOff();
  }

  void done() {
    Navigator.pop(context);
  }

  Future pickCsvFile() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
  }

  Future extractFieldFromCsvFile(file) async {
    return await file
        .transform(utf8.decoder)
        .transform(CsvToListConverter(eol: '\n'))
        .toList();
  }

  Future processCsvFile(file) async {
    final fields = await extractFieldFromCsvFile(File(file.path).openRead());
    setState(() {
      subHeader = null;
      csv = CSV(file.name, fields);
      numberOfFields = csv!.numberOfFields();
      numberOfAccounts = csv!.numberOfRecords() - 1;
    });
  }

  void upload() async {
    FilePickerResult? result = await (pickCsvFile());
    if (result != null) {
      PlatformFile file = result.files.first;
      processCsvFile(file);
    } else {
      Toast.showSomethingWentWrong(context);
    }
  }

  void pick(int id, int picked) {
    if (website == picked || email == picked || password == picked) {
      Toast.showInfo(context, 'Already picked');
      return;
    }
    setState(() {
      if (id == 0) {
        website = picked;
      } else if (id == 1) {
        email = picked;
      } else if (id == 2) {
        password = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: 'Upload CSV',
      subHeader: subHeader,
      isLoading: isLoading,
      widgets: body(),
      bottom: bottom(),
    );
  }

  Widget csvFileIcon() {
    return Icon(
      FontAwesome5.file_csv,
      size: 150.0,
    );
  }

  Widget csvFileNameWidget() {
    return Text(
      '${csv!.name} - $numberOfAccounts Accounts',
      style: TextStyle(
        color: Palette.primaryDark,
        fontSize: Font.h4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget addedAccountsProgressWidget() {
    return Text(
      '$numberOfAddedAccounts / $numberOfAccounts Accounts',
      style: TextStyle(
        color: Palette.primaryDark,
        fontSize: Font.h4,
        fontWeight: finished ? FontWeight.w700 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  List<Widget> fileUploadedHeader() {
    return [csvFileIcon(), csvFileNameWidget(), SizedBox()];
  }

  Widget numberOfFoundedFieldsWidget() {
    return AutoSizeText(
      '$numberOfFields fields got found which one is the:',
      style: TextStyle(
        color: Palette.primaryDark,
        fontSize: Font.h4,
      ),
      maxLines: 1,
      minFontSize: 4,
    );
  }

  List<String> optionsListBuilder() {
    return List.generate(numberOfFields, (option) => (option + 1).toString());
  }

  String valueToString(value) {
    return value == -1 ? '' : (value + 1).toString();
  }

  Widget websitePickerWidget() {
    return Picker(
      id: 0,
      title: 'Website',
      pick: pick,
      options: optionsListBuilder(),
      value: valueToString(website),
      pickedOption: website,
    );
  }

  Widget emailPickerWidget() {
    return Picker(
      id: 1,
      title: 'Email',
      pick: pick,
      options: optionsListBuilder(),
      value: valueToString(email),
      pickedOption: email,
    );
  }

  Widget passwordPickerWidget() {
    return Picker(
      id: 2,
      title: 'Password',
      pick: pick,
      options: optionsListBuilder(),
      value: valueToString(password),
      pickedOption: password,
    );
  }

  List<Widget> fieldsPickerWidget() {
    return [
      numberOfFoundedFieldsWidget(),
      websitePickerWidget(),
      emailPickerWidget(),
      passwordPickerWidget(),
      Spacers.customSpacer(100.0),
    ];
  }

  List<Widget> body() {
    List<Widget> widgets = [];

    if (csv == null)
      return widgets;
    else {
      widgets.addAll(fileUploadedHeader());
    }
    if (isLoading || finished) {
      widgets.add(addedAccountsProgressWidget());
    } else {
      widgets.addAll(fieldsPickerWidget());
    }
    return widgets;
  }

  Widget uploadFileButton() {
    return FAB(icon: FontAwesome5.upload, onPress: upload);
  }

  Widget deleteFileButton() {
    return FAB(icon: FontAwesome5.times, onPress: delete);
  }

  Widget saveFileButton() {
    return FAB(icon: FontAwesome5.check, onPress: save);
  }

  Widget doneButton() {
    return FAB(icon: FontAwesome5.check, onPress: done);
  }

  Widget bottom() {
    if (csv == null) {
      return uploadFileButton();
    } else if (isLoading) {
      return SizedBox();
    } else if (finished) {
      return doneButton();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          deleteFileButton(),
          const SizedBox(width: 100.0),
          saveFileButton(),
        ],
      );
    }
  }
}
