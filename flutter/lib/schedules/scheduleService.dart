import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class ScheduleService with ChangeNotifier {
  // List<Map<String, dynamic>> scheduleListData = [];
  static Future<void> fetchStudents(BuildContext context) async {
    final response = await http.get(Uri.http(url, getAllStudentAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final studentList = data['data'] as List<dynamic>;
      print("fetchStudents: " + studentList.toString());

      // setState(() {
      //   students = studentList.cast<Map<String, dynamic>>();
      // });

      Provider.of<AppStateProvider>(context, listen: false)
          .setStudents(studentList.cast<Student>());
      // .setStudents(studentList.cast<Map<String, dynamic>>());
    } else {
      throw Exception('Failed to fetch students');
    }
  }

  static Future<void> fetchScheduleStudentWeeks(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final studentId =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    print('studentID: ' + studentId!);
    final bodyData = {'studentId': studentId};

    http
        .post(
      Uri.http(url, getAllScheduleStudentWeekAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final scheduleList = data['data'] as List<dynamic>;

        // Gọi hàm để xử lý và cập nhật trạng thái
        Provider.of<AppStateProvider>(context, listen: false)
            .setScheduleStudentWeeks(scheduleList.cast<Map<String, dynamic>>());

        isLoading(false);
      } else {
        throw Exception('Failed to fetchScheduleStudentWeeks');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }

  static Future<void> fetchScheduleStudentTerms(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final studentId =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    print('studentId: ' + studentId!);
    final bodyData = {'studentId': studentId};
    http
        .post(
      Uri.http(url, getAllScheduleStudentTermAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final scheduleList = data['data'] as List<dynamic>;
        print("ScheduleList List: " + scheduleList.toString());

        // Gọi hàm để xử lý và cập nhật trạng thái
        Provider.of<AppStateProvider>(context, listen: false)
            .setScheduleStudentTerms(scheduleList.cast<Map<String, dynamic>>());

        isLoading(false);
      } else {
        throw Exception('Failed to fetchScheduleStudentTerms');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }

  static Future<void> fetchScheduleLecturerWeeks(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final lecturerId =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    print('lecturerId: ' + lecturerId!);
    final bodyData = {'lecturerId': lecturerId};
    http
        .post(
      Uri.http(url, getAllScheduleLecturerWeekAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // final scheduleList = data['data'] as List<dynamic>;0
        final scheduleList = data['data'];
        print("ScheduleList List: " + scheduleList.toString());

        // Gọi hàm để xử lý và cập nhật trạng thái
        Provider.of<AppStateProvider>(context, listen: false)
            .setScheduleLecturerWeeks(
                scheduleList.cast<Map<String, dynamic>>());

        isLoading(false);
      } else {
        throw Exception('Failed to fetchScheduleLecturerWeeks');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }

  static Future<void> fetchScheduleLecturerTerms(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final lecturerId =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    print('lecturerId: ' + lecturerId!);
    final bodyData = {'lecturerId': lecturerId};
    http
        .post(
      Uri.http(url, getAllScheduleLecturerTermAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final scheduleList = data['data'] as List<dynamic>;
        print("ScheduleList List: " + scheduleList.toString());

        // Gọi hàm để xử lý và cập nhật trạng thái
        Provider.of<AppStateProvider>(context, listen: false)
            .setScheduleLecturerTerms(
                scheduleList.cast<Map<String, dynamic>>());

        isLoading(false);
      } else {
        throw Exception('Failed to fetchScheduleLecturerTerms');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }
}
