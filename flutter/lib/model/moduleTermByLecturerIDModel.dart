class ModuleTermByLecturerID {
  final String moduleID;
  final String subjectName;
  final String roomName;
  final DateTime dateStart;
  final DateTime dateEnd;
  final int numberOfCredits;
  final DateTime weekTimeStart;
  final DateTime weekTimeEnd;

  ModuleTermByLecturerID(
      {required this.moduleID,
      required this.subjectName,
      required this.roomName,
      required this.dateStart,
      required this.dateEnd,
      required this.numberOfCredits,
      required this.weekTimeStart,
      required this.weekTimeEnd});

  factory ModuleTermByLecturerID.fromMap(Map<String, dynamic> json) {
    return ModuleTermByLecturerID(
      moduleID: json['moduleID'],
      subjectName: json['subjectName'],
      roomName: json['roomName'],
      dateStart: DateTime.parse(json['dateStart']),
      dateEnd: DateTime.parse(json['dateEnd']),
      numberOfCredits: json['numberOfCredits'],
      weekTimeStart: DateTime.parse(json['weekTimeStart']),
      weekTimeEnd: DateTime.parse(json['weekTimeEnd']),
    );
  }

  @override
  String toString() {
    return '${moduleID} - ${subjectName} - ${roomName} - ${dateStart} - ${dateEnd} - ${numberOfCredits}-${weekTimeStart}-${weekTimeEnd}';
  }
}
