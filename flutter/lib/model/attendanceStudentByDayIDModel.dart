class AttendanceStudentByDayID {
  final String moduleID;
  final String roomName;
  final String lecturerName;
  final String subjectName;
  final List<String> attendance;
  final String day;
  final String time;

  AttendanceStudentByDayID({
    required this.moduleID,
    required this.roomName,
    required this.lecturerName,
    required this.subjectName,
    required this.attendance,
    required this.day,
    required this.time,
  });

  factory AttendanceStudentByDayID.fromMap(Map<String, dynamic> json) {
    return AttendanceStudentByDayID(
      moduleID: json['moduleID'],
      roomName: json['roomName'],
      lecturerName: json['lecturerName'],
      subjectName: json['subjectName'],
      attendance:
          List<String>.from(json['attendance']), // Ensuring List<String>
      day: json['day'],
      time: json['time'],
    );
  }

  @override
  String toString() {
    return '${moduleID} - ${roomName} - ${lecturerName} - ${subjectName} - ${attendance} - ${day} - ${time}';
  }
}
