class Class {
  final String id;
  final String classCode;
  final String className;

  Class({required this.id, required this.classCode, required this.className});

  factory Class.fromMap(Map<String, dynamic> json) {
    return Class(
      id: json['_id'],
      classCode: json['classCode'],
      className: json['className'],
    );
  }

  @override
  String toString() {
    return '${id} - ${classCode} - ${className}';
  }
}
