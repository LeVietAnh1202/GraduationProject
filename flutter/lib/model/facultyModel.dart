import 'package:flutter_todo_app/model/majorModel.dart';

class Faculty {
  final String id;
  final String facultyID;
  final String facultyName;
  final List<Major> majors;
  final int majorNumber;

  Faculty(
      {required this.id,
      required this.facultyID,
      required this.facultyName,
      required this.majors,
      required this.majorNumber});

  factory Faculty.fromMap(Map<String, dynamic> json) {
    List<Major> majors =
        (json['majors'] as List<dynamic>).asMap().entries.map(((e) {
      return Major.fromMap(e.value);
    })).toList();

    return Faculty(
        id: json['_id'],
        facultyID: json['facultyID'],
        facultyName: json['facultyName'],
        majors: majors,
        majorNumber: majors.length);
  }

  @override
  String toString() {
    return '${id} - ${facultyID} - ${facultyName} - ${majors}';
  }
}
