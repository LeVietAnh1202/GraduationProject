import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/moduleTermByLecturerIDModel.dart';
import 'package:flutter_todo_app/model/scheduleAdminTermModel.dart';
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
    final lecturerID =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    final bodyData = {'lecturerID': lecturerID};
    http
        .post(
      Uri.http(url, getAllScheduleLecturerWeekAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final scheduleList = data['data'];

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
    final lecturerID =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    final bodyData = {'lecturerID': lecturerID};
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

  static Future<List<ModuleTermByLecturerID>> fetchAllModuleTermByLecturerIDs(
      BuildContext context,
      ValueChanged<bool> isLoading,
      String lecturerID,
      String semesterID,
      String studentId
      // String subjectID,
      ) async {
    final bodyData = {
      'lecturerID': lecturerID,
      // 'subjectID': subjectID,
      'semesterID': semesterID,
      'studentId': studentId
    };
    isLoading(true);
    return http
        .post(
      Uri.http(url, getAllModuleTermByLecturerIDAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final attendanceTermsList = data['data'] as List<dynamic>;
        print(attendanceTermsList);
        final attendanceTerms = attendanceTermsList
            .map((e) => ModuleTermByLecturerID.fromMap(e))
            .toList();
        print(attendanceTerms);
        Provider.of<AppStateProvider>(context, listen: false)
            .setModuleTermByLecturerIDs(attendanceTerms);
        isLoading(false);
        return attendanceTerms;
      } else {
        throw Exception('Failed to fetch scheduleAdminTerms');
      }
    });
  }

  static Future<List<ScheduleAdminTerm>> fetchScheduleTerms(
    BuildContext context,
    ValueChanged<bool> isLoading,
    String lecturerID,
    String semesterID,
    // String studentId,
  ) async {
    final bodyData = {'lecturerID': lecturerID, 'semesterID': semesterID};
    isLoading(true);
    return http
        .post(
      Uri.http(url, getAllScheduleTermAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final scheduleAdminTermsList = data['data'] as List<dynamic>;
        final scheduleAdminTerms = scheduleAdminTermsList
            .map((e) => ScheduleAdminTerm.fromMap(e))
            .toList();
        Provider.of<AppStateProvider>(context, listen: false)
            .setScheduleAdminTerms(scheduleAdminTerms);
        isLoading(false);
        return scheduleAdminTerms;
      } else {
        throw Exception('Failed to fetch scheduleAdminTerms');
      }
    });
  }
}
