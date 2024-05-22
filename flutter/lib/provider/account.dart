import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account {
  String account;
  String username;
  String role;
  String token;
  // String facultyID;

  Account(
      {required this.account,
      required this.username,
      required this.role,
      required this.token,
      // required this.facultyID
      });
}

class AccountProvider with ChangeNotifier {
  Account? _account;

  Account? get account => _account;

  String? getAccount() {
    return _account?.account;
  }

  Role? getRole() {
    return roleMap[_account?.role];
  }

  String? getUsername() {
    return _account?.username;
  }

  // String? getFacultyID() {
  //   return _account?.facultyID;
  // }

  AccountProvider() {
    print('Khởi tạo AccountProvider');
    restoreFromSharedPreferences(); // Khôi phục từ SharedPreferences
  }

  Future<void> restoreFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? account = prefs.getString('account');
    String? role = prefs.getString('accountRole');
    String? username = prefs.getString('accountUsername');
    String? token = prefs.getString('token');
    // String? facultyID = prefs.getString('facultyID');

    if (account != null && role != null && username != null && token != null 
    // && facultyID != null
    ) {
      _account = Account(
          account: account, role: role, username: username, token: token,
          // facultyID: facultyID
          );
      print('Khởi tạo thành công account');
      notifyListeners();
    } else {
      print('restore false');
    }
  }

  void setAccount(Account account) {
    _account = account;
    saveToSharedPreferences(account); // Lưu vào SharedPreferences
    notifyListeners();
  }

  Future<void> saveToSharedPreferences(Account account) async {
    // lưu trữ state trong bộ nhớ cục bộ để state k bị mất khi reload trang
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('account', account.account);
    prefs.setString('accountRole', account.role);
    prefs.setString('accountUsername', account.username);
    prefs.setString('token', account.token);
    // prefs.setString('facultyID', account.facultyID);
    // Lưu các trường khác nếu cần
  }

  void removePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('account');
    prefs.remove('accountRole');
    prefs.remove('accountUsername');
    prefs.remove('token');
    // prefs.remove('facultyID');
  }
}
