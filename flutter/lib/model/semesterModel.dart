class Semester {
	final String id;
	final String semesterID;
	final String semesterName;

	Semester({
		required this.id,
		required this.semesterID,
		required this.semesterName
	});


	factory Semester.fromMap(Map<String, dynamic> json) {
		return Semester(
			id: json['_id'],
			semesterID: json['semesterID'],
			semesterName: json['semesterName'],
		);
	}

	@override
	String toString() {
		return '${id} - ${semesterID} - ${semesterName}';
	}
}