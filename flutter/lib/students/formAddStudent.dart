import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FromAddStudent extends StatefulWidget {
  const FromAddStudent({Key? key}) : super(key: key);

  @override
  _FromAddStudentState createState() => _FromAddStudentState();
}

class _FromAddStudentState extends State<FromAddStudent> {
  // Define variables to store the form input values
  String? studentId;
  TextEditingController _studentIdController = TextEditingController();
  String? studentName;
  TextEditingController _studentNameController = TextEditingController();
  String? classCode;
  String? gender;
  DateTime? birthDate;
  TextEditingController _birthDateController = TextEditingController();
  bool isAddingStudentSuccess = false;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    classCode =
        'TK18TN'; // Set the initial value to the first item in the dropdown
    gender = 'Nam'; // Set the initial value to the
  }

  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> createStudent() async {
    final data = {
      'studentId': _studentIdController.text,
      'studentName': _studentNameController.text,
      'classCode': classCode,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
    };

    final response = await http.post(
      Uri.http(url, createStudentAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Xử lý thành công
      setState(() {
        isAddingStudentSuccess = true;
      });
    } else {
      // Xử lý lỗi
      print('Lỗi khi thêm sinh viên: ${response.statusCode}');
    }
  }

  void clearForm() {
    setState(() {
      studentId = null;
      _studentIdController.text = '';
      studentName = null;
      _studentNameController.text = '';
      classCode = 'TK18TN';
      gender = 'Nam';
      birthDate = null;
      _birthDateController.text = '';
      isFormValid = false; // Đặt lại giá trị của isFormValid thành false
    });
  }

  bool _checkFormValidity() {
    final studentIdPattern = RegExp(r'^\d{8}$');
    final studentNamePattern = RegExp(r'^[a-zA-Z ]+$');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(birthDate ?? DateTime.now());

    return studentIdPattern.hasMatch(studentId ?? '') &&
        studentNamePattern.hasMatch(studentName ?? '') &&
        (birthDate != null) &&
        (formattedDate == _birthDateController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm sinh viên'),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Mã sinh viên'),
                controller: _studentIdController,
                onChanged: (value) {
                  setState(() {
                    studentId = value;
                    isFormValid =
                        _checkFormValidity(); // Kiểm tra xem các trường đã được điền đầy đủ hay chưa
                  });
                },
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
                items: [
                  DropdownMenuItem(
                    value: 'TK18TN',
                    child: Text('10120TN'),
                  ),
                  DropdownMenuItem(
                    value: 'TK18.3',
                    child: Text('101203'),
                  ),
                  DropdownMenuItem(
                    value: 'ITK18.1',
                    child: Text('101201'),
                  ),
                  DropdownMenuItem(
                    value: 'ITK18.2',
                    child: Text('101202'),
                  ),
                  DropdownMenuItem(
                    value: 'ITK18.4',
                    child: Text('101204'),
                  ),
                  DropdownMenuItem(
                    value: 'ITK18.5',
                    child: Text('101205'),
                  ),
                  DropdownMenuItem(
                    value: 'SEK18.1',
                    child: Text('125201'),
                  ),
                  // Add more dropdown items as needed
                ],
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Giới tính'),
                value: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
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
                        // locale: const Locale("vi", "VN"),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          birthDate = date;
                          _birthDateController.text = DateFormat('dd/MM/yyyy')
                              .format(date); // Update the displayed date format
                          isFormValid = _checkFormValidity();
                        });
                      }
                    },
                  ),
                ),
                readOnly: true,
                controller: _birthDateController,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Additional actions if needed
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // Đổi màu xanh cho nút
            padding: EdgeInsets.all(16.0), // Tăng kích thước của nút
          ),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (isFormValid) {
              await createStudent();
              // Perform form submission or validation
              if (isAddingStudentSuccess) {
                StudentService.fetchStudents(context, (value) => {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thêm sinh viên thành công'),
                    backgroundColor:
                        Colors.green, // Thay đổi màu nền thành màu xanh lá cây
                  ),
                );

                clearForm();
              }
            } else {
              String errorMessage = 'Vui lòng nhập đầy đủ thông tin:';
              if (!(studentId?.isNotEmpty ?? false)) {
                errorMessage += '\n- Mã sinh viên không được để trống';
              } else if (!RegExp(r'^\d{8}$').hasMatch(studentId!)) {
                errorMessage +=
                    '\n- Mã sinh viên không đúng định dạng số hoặc không đủ 8 số';
              }
              if (!(studentName?.isNotEmpty ?? false)) {
                errorMessage += '\n- Tên sinh viên không được để trống';
              } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(studentName!)) {
                errorMessage += '\n- Tên sinh viên không đúng định dạng chữ';
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
          child: Text('Thêm'),
        ),
      ],
    );
  }
}
