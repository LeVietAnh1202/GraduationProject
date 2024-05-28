import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/subjectModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class SubjectService {
  static Future<List<Subject>> fetchSubjects(BuildContext context) async {
    final response = await http.get(Uri.http(url, getAllSubjectAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final subjectList = data['data'];
      final List<Subject> subjects = (subjectList as List<dynamic>)
          .map((e) => Subject.fromMap(e))
          .toList();
      Provider.of<AppStateProvider>(context, listen: false)
          .setSubjects(subjects);
      return subjects;
    } else {
      throw Exception('Failed to fetch subjects');
    }
  }
}
