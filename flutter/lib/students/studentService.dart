import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class StudentService {
  static Future<List<dynamic>> fetchStudents(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final response = await http.get(Uri.http(url, getAllStudentAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final studentsList = data['data'] as List<dynamic>;
      print("Student list: " + studentsList.toString());

      final students = studentsList.map((e) => Student.fromMap(e)).toList();
      print("Students: " + students.toString());

      Provider.of<AppStateProvider>(context, listen: false)
          .setStudents(students);
          // .setStudents(studentsList.cast<Map<String, dynamic>>());
      isLoading(false);
      return studentsList;
    } else {
      throw Exception('Failed to fetch students');
    }
  }

  static getStudentByStudentID(String? studentId) {}
}
