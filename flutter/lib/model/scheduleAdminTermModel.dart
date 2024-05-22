class ScheduleAdminTerm {
  final String day;
  final String time;
  final String moduleID;
  final String subjectName;
  final String roomName;
  final DateTime dateStart;
  final DateTime dateEnd;
  final int numberOfCredits;
  final DateTime weekTimeStart;
  final DateTime weekTimeEnd;

  ScheduleAdminTerm(
      {required this.day,
      required this.time,
      required this.moduleID,
      required this.subjectName,
      required this.roomName,
      required this.dateStart,
      required this.dateEnd,
      required this.numberOfCredits,
      required this.weekTimeStart,
      required this.weekTimeEnd});

  factory ScheduleAdminTerm.fromMap(Map<String, dynamic> json) {
    return ScheduleAdminTerm(
      day: json['day'],
      time: json['time'],
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
    return '${day}-${time}-${moduleID} - ${subjectName} - ${roomName} - ${dateStart} - ${dateEnd} - ${numberOfCredits}-${weekTimeStart}-${weekTimeEnd}';
  }
}
