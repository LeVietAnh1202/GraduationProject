import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/lecturers/lecturerService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FromAddLecturer extends StatefulWidget {
  const FromAddLecturer({Key? key}) : super(key: key);

  @override
  _FromAddLecturerState createState() => _FromAddLecturerState();
}

class _FromAddLecturerState extends State<FromAddLecturer> {
  // Define variables to store the form input values
  String? lecturerID;
  TextEditingController _lecturerIDController = TextEditingController();
  String? lecturerName;
  TextEditingController _lecturerNameController = TextEditingController();
  String? gender;
  DateTime? birthDate;
  TextEditingController _birthDateController = TextEditingController();
  bool isAddingLecturerSuccess = false;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Set the initial value to the
  }

  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> createLecturer() async {
    final data = {
      'lecturerID': _lecturerIDController.text,
      'lecturerName': _lecturerNameController.text,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
    };

    final response = await http.post(
      Uri.http(url, createLecturerAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Xử lý thành công
      setState(() {
        isAddingLecturerSuccess = true;
      });
    } else {
      // Xử lý lỗi
      print('Lỗi khi thêm giảng viên: ${response.statusCode}');
    }
  }

  void clearForm() {
    setState(() {
      lecturerID = null;
      _lecturerIDController.text = '';
      lecturerName = null;
      _lecturerNameController.text = '';
      gender = 'Nam';
      birthDate = null;
      _birthDateController.text = '';
      isFormValid = false; // Đặt lại giá trị của isFormValid thành false
    });
  }

  bool _checkFormValidity() {
    final lecturerIDPattern = RegExp(r'^\d{8}$');
    final lecturerNamePattern = RegExp(r'^[a-zA-Z ]+$');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(birthDate ?? DateTime.now());

    return lecturerIDPattern.hasMatch(lecturerID ?? '') &&
        lecturerNamePattern.hasMatch(lecturerName ?? '') &&
        (birthDate != null) &&
        (formattedDate == _birthDateController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm giảng viên'),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Mã giảng viên'),
                controller: _lecturerIDController,
                onChanged: (value) {
                  setState(() {
                    lecturerID = value;
                    isFormValid =
                        _checkFormValidity(); // Kiểm tra xem các trường đã được điền đầy đủ hay chưa
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên giảng viên'),
                controller: _lecturerNameController,
                onChanged: (value) {
                  setState(() {
                    lecturerName = value;
                    isFormValid =
                        _checkFormValidity(); // Kiểm tra xem các trường đã được điền đầy đủ hay chưa
                  });
                },
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
              await createLecturer();
              // Perform form submission or validation
              if (isAddingLecturerSuccess) {
                LecturerService.fetchLecturers(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thêm giảng viên thành công'),
                    backgroundColor:
                        Colors.green, // Thay đổi màu nền thành màu xanh lá cây
                  ),
                );

                clearForm();
              }
            } else {
              String errorMessage = 'Vui lòng nhập đầy đủ thông tin:';
              if (!(lecturerID?.isNotEmpty ?? false)) {
                errorMessage += '\n- Mã giảng viên không được để trống';
              } else if (!RegExp(r'^\d{8}$').hasMatch(lecturerID!)) {
                errorMessage +=
                    '\n- Mã giảng viên không đúng định dạng số hoặc không đủ 8 số';
              }
              if (!(lecturerName?.isNotEmpty ?? false)) {
                errorMessage += '\n- Tên giảng viên không được để trống';
              } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(lecturerName!)) {
                errorMessage += '\n- Tên giảng viên không đúng định dạng chữ';
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
