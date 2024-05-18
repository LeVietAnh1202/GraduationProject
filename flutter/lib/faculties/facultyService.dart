import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class FacultyService {
  static Future<List<Faculty>> fetchFaculties(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final response = await http.get(Uri.http(url, getAllFacultyAPI));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final facultiesList = (data['data']);
      
      final List<Faculty> faculties = (facultiesList as List<dynamic>)
          .map((e) => Faculty.fromMap(e))
          .toList();

      Provider.of<AppStateProvider>(context, listen: false)
          .setFaculties(faculties);
      isLoading(false);

      return faculties;
    } else {
      throw Exception('Failed to fetch faculties');
    }
  }
}
