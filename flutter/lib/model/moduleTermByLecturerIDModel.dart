class ModuleTermByLecturerID {
  final String moduleID;
  final String subjectName;
  final String roomName;
  final String lecturerName;
  final DateTime dateStart;
  final DateTime dateEnd;
  final int numberOfCredits;

  ModuleTermByLecturerID(
      {required this.moduleID,
      required this.subjectName,
      required this.roomName,
      required this.lecturerName,
      required this.dateStart,
      required this.dateEnd,
      required this.numberOfCredits});

  factory ModuleTermByLecturerID.fromMap(Map<String, dynamic> json) {
    return ModuleTermByLecturerID(
        moduleID: json['moduleID'],
        subjectName: json['subjectName'],
        roomName: json['roomName'],
        lecturerName: json['lecturerName'],
        dateStart: DateTime.parse(json['dateStart']),
        dateEnd: DateTime.parse(json['dateEnd']),
        numberOfCredits: json['numberOfCredits']);
  }

  @override
  String toString() {
    return '${moduleID} - ${subjectName} - ${roomName} - ${lecturerName} - ${dateStart} - ${dateEnd} - ${numberOfCredits}';
  }
}
