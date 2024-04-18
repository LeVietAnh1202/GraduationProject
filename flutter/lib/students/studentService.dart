import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class StudentService {
  static Future<int> fetchStudents(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final response = await http.get(Uri.http(url, getAllStudentAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final studentList = data['data'] as List<dynamic>;
      print("Student list: " + studentList.toString());

      // setState(() {
      //   students = studentList.cast<Map<String, dynamic>>();
      // });

      Provider.of<AppStateProvider>(context, listen: false)
          .setStudents(studentList.cast<Map<String, dynamic>>());
      isLoading(false);
      return studentList.length;
    } else {
      throw Exception('Failed to fetch students');
    }
  }

  static getStudentByStudentID(String? studentId) {}
}
