class ScheduleAdminTerm {
	final String day;
	final String time;
	final String moduleID;
	final String subjectName;
	final String lecturerName;
	final String roomName;
	final DateTime dateStart;
	final DateTime dateEnd;
	final int numberOfCredits;

	ScheduleAdminTerm({
		required this.day,
		required this.time,
		required this.moduleID,
		required this.subjectName,
		required this.lecturerName,
		required this.roomName,
		required this.dateStart,
		required this.dateEnd,
		required this.numberOfCredits
	});


	factory ScheduleAdminTerm.fromMap(Map<String, dynamic> json) {
		return ScheduleAdminTerm(
			day: json['day'],
			time: json['time'],
			moduleID: json['moduleID'],
			subjectName: json['subjectName'],
			lecturerName: json['lecturerName'],
			roomName: json['roomName'],
			dateStart: DateTime.parse(json['dateStart']),
			dateEnd: DateTime.parse(json['dateEnd']),
			numberOfCredits: json['numberOfCredits'],
		);
	}

	@override
	String toString() {
		return '${day} - ${time} - ${moduleID} - ${subjectName} - ${lecturerName} - ${roomName} - ${dateStart} - ${dateEnd} - ${numberOfCredits}';
	}
}