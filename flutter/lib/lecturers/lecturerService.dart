import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class LecturerService {
  static Future<void> fetchLecturers(BuildContext context) async {
    final response = await http.get(Uri.http(url, getAllLecturerAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final lecturerList = data['data'] as List<dynamic>;
      print("Lecturer list: " + lecturerList.toString());

      // setState(() {
      //   students = studentList.cast<Map<String, dynamic>>();
      // });

      Provider.of<AppStateProvider>(context, listen: false)
          .setLecturers(lecturerList.cast<Map<String, dynamic>>());
    } else {
      throw Exception('Failed to fetch lecturers');
    }
  }

  // static getLecturerByLecturerID(String? lecturerId) {}
}
