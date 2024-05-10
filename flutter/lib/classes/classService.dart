import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/classModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class ClassService {
  static Future<List<Class>> fetchClasses(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final response = await http.get(Uri.http(url, getAllClassAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final classesList = data['data'] as List<dynamic>;
      print("classesList: " + classesList.toString());
      final classes = classesList.map((e) => Class.fromMap(e)).toList();
      Provider.of<AppStateProvider>(context, listen: false).setClasses(classes);
      print("classes: " + classes.toString());
      isLoading(false);

      return classes;
    } else {
      throw Exception('Failed to fetch classes');
    }
  }
}
