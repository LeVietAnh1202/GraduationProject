import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:intl/intl.dart';

class Utilities {
  static String formatDate(String inputDate) {
    // ignore: unused_local_variable
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    final outputFormat = DateFormat('dd/MM/yyyy');

    return outputFormat.format(inputFormat.parse(inputDate));
  }
  
  static String formatDateString(DateTime inputDate) {
    // ignore: unused_local_variable
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    final outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    return outputFormat.format(inputDate);
  }

  static Widget attendanceIcon(int? attendance) {
    return (attendance == null)
        ? Text('')
        : (attendance == 0)
            ? Icon(
                Icons.close,
                color: Colors.red[600],
                size: attendanceIconSize,
              )
            : (attendance == 1)
                ? Icon(
                    Icons.horizontal_rule,
                    color: Colors.amber[600],
                    size: attendanceIconSize,
                  )
                : Icon(
                    Icons.check,
                    color: Colors.green[600],
                    size: attendanceIconSize,
                  );
  }

  static String attendanceString(int? attendance) {
    return (attendance == null)
        ? ''
        : (attendance == 0)
            ? 'x'
            : (attendance == 1)
                ? '-'
                : 'v';
  }

  static TextButton exportFileButton(Function()? onPressFunction) {
    return TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Đổi màu xanh cho nút
          padding: EdgeInsets.all(16.0), // Tăng kích thước của nút
        ),
        child: Text(
          'Xuất file',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPressFunction);
  }
}
