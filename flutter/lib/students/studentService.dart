import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class StudentService {
  static Future<List<Student>> fetchStudents(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final role = Provider.of<AccountProvider>(context, listen: false).getRole();
    Response? response;
    if (role == Role.aao) {
      final lecturerID =
          Provider.of<AccountProvider>(context, listen: false).getAccount();
      final bodyData = {'lecturerID': lecturerID};
      response = await http.post(Uri.http(url, getStudentsByFacultyIDAPI),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bodyData));
    }
    if (role == Role.admin)
      response = await http.get(Uri.http(url, getAllStudentAPI));
    if (response!.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final studentsList = data['data'];
      final List<Student> students = (studentsList as List<dynamic>)
          .map((e) => Student.fromMap(e))
          .toList();

      Provider.of<AppStateProvider>(context, listen: false)
          .setStudents(students);
      isLoading(false);

      return students;
    } else {
      throw Exception('Failed to fetch students');
    }
  }

  static Future<List<Student>> fetchStudentByModuleID(BuildContext context,
      ValueChanged<bool> isLoading, String moduleID) async {
    final bodyData = {'moduleID': moduleID};
    return http
        .post(
      Uri.http(url, getStudentByModuleIDAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final studentList = data['data'] as List<dynamic>;
        final students = studentList.map((e) => Student.fromMap(e)).toList();
        Provider.of<AppStateProvider>(context, listen: false)
            .setStudents(students);
        isLoading(false);
        return students;
      } else {
        throw Exception('Failed to fetchStudentByModuleID');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }

  static Future<String> createStudent(Map<String, String> inforStudent) async {
    final response = await http.post(
      Uri.http(url, createStudentAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inforStudent),
    );
    String message = '';
    if (response.statusCode == 200) {
      // Xử lý thành công
      message = 'Thêm sinh viên thành công';
    } else {
      // Xử lý lỗi
      message = 'Lỗi khi thêm sinh viên';
    }
    return json.encode({'message': message, 'statusCode': response.statusCode});
  }

  static Future<String> deleteStudent(String studentId) async {
    try {
      final response = await http.delete(
        Uri.http(url_ras, '$deleteStudentAPI/$studentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Thêm các headers khác nếu cần
        },
      );
      String message = '';
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        // Xóa thành công, không cần thực hiện gì cả
        message = 'Xóa thành công sinh viên: ${body['data']['studentName']}';
      } else {
        // Xử lý lỗi nếu cần
        message = 'Lỗi khi xóa sinh viên: ${body['data']['studentName']}';
      }
      return json.encode({
        'message': message,
        'statusCode': response.statusCode,
        'body': body
      });
    } catch (error) {
      throw Exception('Error deleting student: $error');
    }
  }
}
