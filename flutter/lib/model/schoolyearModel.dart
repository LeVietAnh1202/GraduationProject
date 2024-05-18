import 'package:flutter_todo_app/model/semesterModel.dart';

class Schoolyear {
  final String id;
  final String schoolYearID;
  final String schoolYearName;
  final List<Semester> semesters;

  Schoolyear(
      {required this.id,
      required this.schoolYearID,
      required this.schoolYearName,
      required this.semesters});

  factory Schoolyear.fromMap(Map<String, dynamic> json) {
    List<Semester> semesters =
        (json['semesters'] as List<dynamic>).asMap().entries.map(((e) {
      return Semester.fromMap(e.value);
    })).toList();
    return Schoolyear(
      id: json['_id'],
      schoolYearID: json['schoolYearID'],
      schoolYearName: json['schoolYearName'],
      semesters: semesters,
    );
  }

  @override
  String toString() {
    return '${id} - ${schoolYearID} - ${schoolYearName} - ${semesters}';
  }
}
