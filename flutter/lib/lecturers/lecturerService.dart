import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/model/lecturerModel.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class LecturerService {
  static Future<List<Lecturer>> fetchLecturers(
      // BuildContext context
      Role? role,
      String? lecturerID) async {
    Response? response;
    if (role == Role.aao) {
      final bodyData = {'lecturerID': lecturerID};
      response = await http.post(Uri.http(url, getAllLecturerByFacultyIDAPI),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bodyData));
    }
    if (role == Role.admin)
      response = await http.get(Uri.http(url, getAllLecturerAPI));

    if (response!.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final lecturerList = data['data'];
      final List<Lecturer> lecturers = (lecturerList as List<dynamic>)
          .map((e) => Lecturer.fromMap(e))
          .toList();
      // Provider.of<AppStateProvider>(context, listen: false)
      //     .setLecturers(lecturers);
      return lecturers;
    } else {
      throw Exception('Failed to fetch lecturers');
    }
  }
}
