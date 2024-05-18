class Student {
  final String id;
  final String studentId;
  final String studentName;
  final String classCode;
  final String gender;
  final String specializationID;
  final String fingerprintID;
  final DateTime birthDate;
  final String avatar;
  final String video;

  // Student({
  //   required this.id,
  //   required this.studentId,
  //   required this.studentName,
  //   required this.classCode,
  //   required this.gender,
  //   required this.fingerprintID,
  //   required this.birthDate,
  //   required this.avatar,
  // });

  // factory Student.fromMap(Map<String, dynamic> json) {
  //   return Student(
  //     id: json['_id'],
  //     studentId: json['studentId'],
  //     studentName: json['studentName'],
  //     classCode: json['classCode'],
  //     gender: json['gender'],
  //     fingerprintID: json['fingerprintID'],
  //     birthDate: DateTime.parse(json['birthDate']),
  //     avatar: json['avatar'],
  //   );
  // }

  Student({
    this.id = '',
    this.studentId = '',
    this.studentName = '',
    this.classCode = '',
    this.gender = '',
    this.specializationID = '',
    this.fingerprintID = '',
    DateTime? birthDate, // Tham số tùy chọn
    this.avatar = '',
    this.video = '',
  }) : birthDate = birthDate ?? DateTime(1990, 1, 1); // Gán giá trị mặc định nếu không có ngày sinh được cung cấp;

  factory Student.fromMap(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      classCode: json['classCode'] ?? '',
      gender: json['gender'] ?? '',
      specializationID: json['specializationID'] ?? '',
      fingerprintID: json['fingerprintID'] ?? '',
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      avatar: json['avatar'] ?? '',
      video: json['video'] ?? '',
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return '${studentId} - ${studentName}';
  }
}