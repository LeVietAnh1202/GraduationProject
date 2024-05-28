import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AttendanceService with ChangeNotifier {
  static Future<List<dynamic>> fetchAttendanceLecturerTerms(
      BuildContext context,
      ValueChanged<bool> isLoading,
      String moduleID) async {
    final lecturerID =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    final bodyData = {'lecturerID': lecturerID, 'moduleID': moduleID};

    return http
        .post(
      Uri.http(url, getAllAttendanceLecturerTermAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final attendanceList = data['data'] as List<dynamic>;

        Provider.of<AppStateProvider>(context, listen: false)
            .setAttendanceLecturerTerms(
                attendanceList.cast<Map<String, dynamic>>());

        isLoading(false);
        return attendanceList;
      } else {
        throw Exception('Failed to fetchAttendanceStudentWeeks');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }

  static Future<void> fetchAttendanceLecturerWeeks(
      BuildContext context, ValueChanged<bool> isLoading, String dayID) async {
    final lecturerID =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    final bodyData = {'lecturerID': lecturerID, 'dayID': dayID};
    http
        .post(
      Uri.http(url, getAllAttendanceLecturerWeekAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final attendanceList = data['data'] as Map<String, dynamic>;

        Provider.of<AppStateProvider>(context, listen: false)
            .setAttendanceLecturerWeeks(attendanceList);

        isLoading(false);
      } else {
        throw Exception('Failed to fetchAttendanceLecturerWeeks');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }

  static Future<void> fetchAttendanceStudentTerms(BuildContext context,
      ValueChanged<bool> isLoading, String moduleID) async {
    final studentId =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    final bodyData = {'studentId': studentId, 'moduleID': moduleID};

    http
        .post(
      Uri.http(url, getAllAttendanceStudentTermAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final attendanceList = data['data'] as Map<String, dynamic>;

        Provider.of<AppStateProvider>(context, listen: false)
            .setAttendanceStudentTerms(attendanceList);

        isLoading(false);
      } else {
        throw Exception('Failed to fetchAttendanceStudentTerms');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }
}
