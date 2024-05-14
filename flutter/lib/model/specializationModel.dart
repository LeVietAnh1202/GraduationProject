class Specialization {
  final String id;
  final String specializationID;
  final String specializationName;

  Specialization(
      {required this.id,
      required this.specializationID,
      required this.specializationName});

  factory Specialization.fromMap(Map<String, dynamic> json) {
    return Specialization(
        id: json['_id'],
        specializationID: json['specializationID'],
        specializationName: json['specializationName']);
  }

  @override
  String toString() {
    return '${id} - ${specializationID} - ${specializationName}';
  }
}
