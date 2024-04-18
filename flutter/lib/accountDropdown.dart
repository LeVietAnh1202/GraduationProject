import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/loginPage.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDropdown extends StatefulWidget {
  @override
  State<AccountDropdown> createState() => _AccountDropdownState();
}

class _AccountDropdownState extends State<AccountDropdown> {
  late SharedPreferences prefs;
  late String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initSharedPref();
    Future.delayed(Duration.zero, () {
        initSharedPref(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }
  
  void logoutUser() {
    // Xóa token khỏi SharedPreferences
    Provider.of<AccountProvider>(context, listen: false).removePrefs();
    Provider.of<AppStateProvider>(context, listen: false).removePrefs();

    // Chuyển người dùng về màn hình đăng nhập hoặc màn hình chào mừng
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return PopupMenuButton<int>(
  //     itemBuilder: (context) => [
  //       PopupMenuItem(
  //         value: 0,
  //         child: ListTile(
  //           leading: Icon(Icons.account_circle),
  //           title: Text('Thông tin tài khoản'),
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: 1,
  //         child: ListTile(
  //           leading: Icon(Icons.lock),
  //           title: Text('Đổi mật khẩu'),
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: 2,
  //         child: ListTile(
  //           leading: Icon(Icons.logout),
  //           title: Text('Đăng xuất'),
  //           onTap: () {
  //             logoutUser();
  //           },
  //         ),
  //       ),
  //     ],
  //     onSelected: (value) {
  //       // Handle dropdown item click
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () {
            // Hiển thị PopupMenuButton khi nút được nhấn
            showMenu<int>(
              context: context,
              position: RelativeRect.fromLTRB(
                MediaQuery.of(context).size.width - 50, // Right offset
                appBarHeight, // Top offset
                0,
                0,
              ),
              items: [
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Thông tin tài khoản'),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Đổi mật khẩu'),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Đăng xuất'),
                    onTap: () {
                      logoutUser();
                    },
                  ),
                ),
              ],
            );
          },
          child: Container(
            color: Colors.blue[300],
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 8.0),
                Text('Xin chào ${context.watch<AccountProvider>().getUsername()}'),
                SizedBox(width: 8.0),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      );
  }
}
