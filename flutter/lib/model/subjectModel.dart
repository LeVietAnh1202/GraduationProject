class Subject {
  final String id;
  final String subjectID;
  final String subjectName;
  final int numberOfCredits;
  final int numberOfLessons;

  Subject(
      {required this.id,
      required this.subjectID,
      required this.subjectName,
      required this.numberOfCredits,
      required this.numberOfLessons});

  factory Subject.fromMap(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'],
      subjectID: json['subjectID'],
      subjectName: json['subjectName'],
      numberOfCredits: json['numberOfCredits'],
      numberOfLessons: json['numberOfLessons'],
    );
  }

  @override
  String toString() {
    return '${id} - ${subjectID} - ${subjectName} - ${numberOfCredits} - ${numberOfLessons}';
  }
}
