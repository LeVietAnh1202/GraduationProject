import 'package:flutter_todo_app/model/specializationModel.dart';

class Major {
  final String id;
  final String majorID;
  final String majorName;
  final List<Specialization> specializations;
  final int specializationNumber;

  Major(
      {required this.id,
      required this.majorID,
      required this.majorName,
      required this.specializations,
      required this.specializationNumber});

  factory Major.fromMap(Map<String, dynamic> json) {
    List<Specialization> specializations =
        (json['specializations'] as List<dynamic>).asMap().entries.map(((e) {
      return Specialization.fromMap(e.value);
    })).toList();

    return Major(
        id: json['_id'],
        majorID: json['majorID'],
        majorName: json['majorName'],
        specializations: specializations,
        specializationNumber: specializations.length);
  }

  @override
  String toString() {
    return '${id} - ${majorID} - ${majorName} - ${specializations}';
  }
}
