

class Lecturer {
  final String id;
  final String lecturerID;
  final String lecturerName;
  final String gender;
  final DateTime birthDate;
  final String position;
  final String facultyID;

  Lecturer(
      {required this.id,
      required this.lecturerID,
      required this.lecturerName,
      required this.gender,
      required this.birthDate,
      required this.position,
      required this.facultyID});

  factory Lecturer.fromMap(Map<String, dynamic> json) {
    return Lecturer(
      id: json['_id'],
      lecturerID: json['lecturerID'],
      lecturerName: json['lecturerName'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
      position: json['position'],
      facultyID: json['facultyID'],
    );
  }

  @override
  String toString() {
    return '${id} - ${lecturerID} - ${lecturerName} - ${gender} - ${birthDate} - ${position} - ${facultyID}';
  }
}
