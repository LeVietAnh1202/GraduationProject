import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/classes/classService.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditStudent extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String classCode;
  final String gender;
  final DateTime birthDate;

  const EditStudent({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.classCode,
    required this.gender,
    required this.birthDate,
  }) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  // late TextEditingController _studentNameController;
  late String studentId;
  String? studentName;
  TextEditingController _studentNameController = TextEditingController();

  TextEditingController _birthDateController = TextEditingController();
  late String gender;
  late DateTime birthDate;
  String? classCode;
  bool isFormValid = false;
  bool isEditStudentSuccess = false;

  @override
  void initState() {
    super.initState();
    _studentNameController = TextEditingController(text: widget.studentName);
    _birthDateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(widget.birthDate));
    // Kiểm tra nếu giới tính ban đầu là null, đặt giới tính mặc định là "Nam"
    studentId = widget.studentId;
    gender = widget.gender;
    classCode = widget.classCode;
    birthDate = widget.birthDate;
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    await ClassService.fetchClasses(context, (value) => {});
  }

  bool _checkFormValidity() {
    final studentIdPattern = RegExp(r'^\d{8}$');
    final studentNamePattern = RegExp(r'^[a-zA-ZÀ-ỹ ]+$');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(birthDate);

    return studentIdPattern.hasMatch(studentId) &&
        studentNamePattern.hasMatch(studentName ?? '') &&
        (formattedDate == _birthDateController.text);
  }

  Map<String, String> getInforStudent() {
    // final studentId = widget.studentId;
    final studentName = _studentNameController.text;

    return {
      'studentId': studentId,
      'studentName': studentName,
      'classCode': classCode!,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
    };
  }

  Future<void> editStudent(Map<String, String> inforStudent) async {
    final response = await http.post(
      Uri.http(url, editStudentAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inforStudent),
    );

    if (response.statusCode == 200) {
      // Xử lý thành công
      setState(() {
        isEditStudentSuccess = true;
      });
    } else {
      // Xử lý lỗi
      print(
          'Lỗi khi cập nhật thông tin sinh viên: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cập nhật thông tin sinh viên'),
      content: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mã sinh viên'),
                  initialValue:
                      widget.studentId, // Hiển thị mã sinh viên ban đầu
                  readOnly: true, // Không cho phép chỉnh sửa
                  enabled: false,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Tên sinh viên'),
                  controller: _studentNameController,
                  onChanged: (value) {
                    setState(() {
                      studentName = value;
                      isFormValid =
                          _checkFormValidity(); // Kiểm tra xem các trường đã được điền đầy đủ hay chưa
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Mã lớp'),
                  value: classCode,
                  onChanged: (value) {
                    setState(() {
                      classCode = value;
                    });
                  },
                  items: context
                      .watch<AppStateProvider>()
                      .appState!
                      .classes
                      .asMap()
                      .entries
                      .map((entry) {
                    final _class = entry.value;

                    return DropdownMenuItem(
                      value: _class.classCode,
                      child: Text(_class.classCode),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Giới tính'),
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Nam',
                      child: Text('Nam'),
                    ),
                    DropdownMenuItem(
                      value: 'Nữ',
                      child: Text('Nữ'),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ngày tháng năm sinh',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: birthDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            birthDate = date;
                            _birthDateController.text = DateFormat('dd/MM/yyyy')
                                .format(
                                    date); // Update the displayed date format
                            isFormValid = _checkFormValidity();
                          });
                        }
                      },
                    ),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(birthDate),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // Change button color to grey
            padding: EdgeInsets.all(16.0), // Increase button size
          ),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (isFormValid) {
              final inforStudent = getInforStudent();
              await editStudent(inforStudent);

              if (isEditStudentSuccess) {
                StudentService.fetchStudents(context, (value) => {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cập nhật sinh viên thành công'),
                    backgroundColor:
                        Colors.green, // Thay đổi màu nền thành màu xanh lá cây
                  ),
                );
                Navigator.of(context).pop();
              }
            } else {
              String errorMessage = 'Vui lòng nhập đầy đủ thông tin:';
              if (!(studentName?.isNotEmpty ?? false)) {
                errorMessage += '\n- Tên sinh viên không được để trống';
              } else if (!RegExp(r'^[a-zA-ZÀ-ỹ ]+$').hasMatch(studentName!)) {
                errorMessage += '\n- Tên sinh viên không đúng định dạng';
              }

              if (birthDate == null) {
                errorMessage += '\n- Ngày tháng năm sinh không được để trống';
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Đổi màu xanh cho nút
            padding: EdgeInsets.all(16.0), // Tăng kích thước của nút
          ),
          child: Text('Cập nhật'),
        ),
      ],
    );
  }
}
