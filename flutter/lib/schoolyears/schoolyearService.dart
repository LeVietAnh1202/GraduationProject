import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/schoolyearModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class SchoolyearService {
  static Future<List<Schoolyear>> fetchSchoolyears(
      BuildContext context, ValueChanged<bool> isLoading) async {
    final response = await http.get(Uri.http(url, getAllSchoolyearAPI));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final schoolyearsList = data['data'] as List<dynamic>;
      final schoolyears =
          schoolyearsList.map((e) => Schoolyear.fromMap(e)).toList();
      Provider.of<AppStateProvider>(context, listen: false)
          .setSchoolyears(schoolyears);
      isLoading(false);

      return schoolyears;
    } else {
      throw Exception('Failed to fetch schoolyears');
    }
  }
}
