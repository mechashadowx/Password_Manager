import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pm/Models/models.dart';
import 'package:pm/Services/services.dart';

class CurrentUser extends User {
  static const smsOtp = 'SMS_OTP';
  static const googleOtp = 'Google_OTP';

  late API api;
  String? currentDevice;
  String? googleAuthOtpLink;

  CurrentUser() {
    api = API();
    accounts = [];
  }

  testApi() async {
    try {
      Response response = await (api.test());
      if (response.statusCode == 200) {}
    } catch (error) {}
  }

  setCurrentUserInfo(response) {
    api.setHeaders(response.headers.map['set-cookie']);
    int? userId = response.data['ID'];
    api.setUserId(userId);
    this.setId(userId);
  }

  clearCurrentUserInfo() {
    api.clearUserId();
    this.id = -1;
  }

  checkSignInState(response) {
    int? isVerfiedPhone = response.data['isVerfied'];
    int? isTrustedDevice = response.data['isTrusted'];
    if (isVerfiedPhone == 0) {
      return SignInState.needPhoneAuth;
    } else if (isTrustedDevice == 0) {
      return SignInState.firstTimeDevice;
    } else {
      return SignInState.allowed;
    }
  }

  signUp() async {
    await setSerialNumber();
    await setFirebaseToken();
    bool success = false;
    try {
      Response response = await (api.signUp(this.toJsonForSignUp()));
      setCurrentUserInfo(response);
      success = true;
    } catch (error) {}
    return success;
  }

  signIn() async {
    await setSerialNumber();
    await setFirebaseToken();
    clearCurrentUserInfo();
    var signInState = SignInState.userNotFound;
    try {
      Response response = await (api.logIn(this.toJsonForSignIn()));
      setCurrentUserInfo(response);
      this.email = response.data['email'];
      signInState = checkSignInState(response);
    } catch (error) {}
    return signInState;
  }

  setFirebaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    this.firebaseToken = token;
  }

  requestOtpOfType(otpType) async {
    bool success = false;
    try {
      if (otpType == smsOtp) {
        Response response = await (api.requestSmsOtp());
        phone = response.data['phoneNumber'];
      } else if (otpType == googleOtp) {
        Response response = await (api.requestGoogleOtp());
        googleAuthOtpLink = response.data['url'];
      } else {
        success = false;
      }
      success = true;
    } catch (error) {}
    return success;
  }

  checkOtpOfType(otpType, otp) async {
    bool success = false;
    try {
      Response response;
      if (otpType == smsOtp) {
        response = await (api.checkSmsOtp({'passcode': otp}));
      } else if (otpType == googleOtp) {
        response = await (api.checkGoogleOtp({'passcode': otp}));
      } else {
        return false;
      }
      api.setHeaders(response.headers.map['set-cookie']);
      success = true;
    } catch (error) {}
    return success;
  }

  getAllAccounts() async {
    bool success = false;
    try {
      Response response = await api.getAllAccounts();
      accounts = List<Account>.from(
        (response.data).map(
          (json) => Account.fromJson(json, key),
        ),
      );
      success = true;
    } catch (error) {}
    return success;
  }

  addAccount(account) async {
    account.setDate();
    bool success = false;
    try {
      Response response = await (api.addAccount(account.toJson(this.key)));
      account.id = response.data['ID'];
      account.isCompPassword = response.data['isComp'];
      accounts.add(account);
      success = true;
      notifyListeners();
    } catch (error) {}
    return success;
  }

  updateAccount(account) async {
    var success = false;
    var accountIndex = this.getAccountIndexById(account.id);
    try {
      Response response = await (api.updateAccount(
        account.id,
        account.toJson(key),
      ));
      account.isCompPassword = response.data['isComp'];
      if (accounts[accountIndex].password != account.password) {
        account.setDate();
      }
      accounts[accountIndex] = account;
      notifyListeners();
      success = true;
    } catch (error) {}
    return success;
  }

  deleteAccount(accountId) async {
    var success = false;
    var accountIndex = this.getAccountIndexById(accountId);
    try {
      await api.deleteAccount(accountId);
      accounts.removeAt(accountIndex);
      notifyListeners();
      success = true;
    } catch (error) {}
    return success;
  }

  Future getNotificaionFreq() async {
    bool success = false;
    try {
      Response response = await (api.getNotificationFreq());
      notificationFreq =
          convertNotificationFreqNumberOfMonthsToIndex(response.data['freq']);
      notifyListeners();
    } catch (error) {}
    return success;
  }

  Future changeNotificationFreq(int freq) async {
    bool success = false;
    try {
      await api.changeNotificationFreq(
        this.convertNotificationFreqIndexToNumberOfMonths(freq),
      );
      this.notificationFreq = freq;
      success = true;
      notifyListeners();
    } catch (error) {}
    return success;
  }

  changeHint(String hint) async {
    bool success = false;
    try {
      await (api.changeHint({'hint': hint}));
      success = true;
    } catch (error) {}
    return success;
  }

  sendHint(username) async {
    try {
      await api.sendHint({'username': username});
    } catch (error) {}
  }

  Future<bool> changePassword(String newPassword) async {
    bool success = false;
    String oldPasswordHash = this.hashPassword();
    this.password = newPassword;
    generateKeyFromPassword(password!);
    String newPasswordHash = this.hashPassword();
    Map<String, dynamic> newInfo = {};
    newInfo['newPassword'] = newPasswordHash;
    newInfo['oldPassword'] = oldPasswordHash;
    newInfo['hashPassword'] = this.convertPasswordToSha1();
    List<Map<String, dynamic>> accounts = [];
    for (Account account in this.accounts) {
      accounts.add(account.toJsonForNewPassword(this.key));
    }
    newInfo['accounts'] = accounts;
    try {
      await api.changePassword(newInfo);
      success = true;
    } catch (error) {}
    return success;
  }
}
