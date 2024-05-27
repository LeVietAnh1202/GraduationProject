import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class FacultyService {
  static Future<List<Faculty>> fetchFaculties(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final role = Provider.of<AccountProvider>(context, listen: false).getRole();
    Response? response;
    if (role == Role.aao) {
      final lecturerID =
          Provider.of<AccountProvider>(context, listen: false).getAccount();
      final bodyData = {'lecturerID': lecturerID};
      print(bodyData);
      response = await http.post(Uri.http(url, getAllFacultyByLecturerIDAPI),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bodyData));
      print(response.body);
    }
    if (role == Role.admin)
      response = await http.get(Uri.http(url, getAllFacultyAPI));
    if (response!.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> facultiesList = [];
      if (role == Role.aao) {
        facultiesList.add(data['data']);
      } else
        facultiesList = (data['data']);
      final List<Faculty> faculties =
          facultiesList.map((e) => Faculty.fromMap(e)).toList();
      print("faculties: " + faculties.toString());

      Provider.of<AppStateProvider>(context, listen: false)
          .setFaculties(faculties);
      isLoading(false);

      return faculties;
    } else {
      throw Exception('Failed to fetch faculties');
    }
  }

  static Future<List<Faculty>> fetchFacultyByStudentID(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final studentId =
        Provider.of<AccountProvider>(context, listen: false).account?.account;
    final bodyData = {'studentId': studentId};
    return http
        .post(
      Uri.http(url, getFacultyByStudentIDAPI),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        List<dynamic> facultyList = [];
        facultyList.add(data['data']);
        print('data: ' + facultyList.toString());

        final List<Faculty> faculties = facultyList
            .map((e) => Faculty.fromMap(e))
            .toList();
        print(faculties); 
        Provider.of<AppStateProvider>(context, listen: false)
            .setFaculties(faculties);
        isLoading(false);
        print('faculties: ' + faculties.toString());
        return faculties;
      } else {
        throw Exception('Failed to fetch faculty by student ID');
      }
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
    });
  }
}
