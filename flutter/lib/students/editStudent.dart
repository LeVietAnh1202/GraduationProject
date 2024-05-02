import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditStudent extends StatefulWidget {
  final String studentId;
  final String initialStudentName;
  final String initialGender;
  final DateTime initialBirthDate;

  const EditStudent({
    Key? key,
    required this.studentId,
    required this.initialStudentName,
    required this.initialGender,
    required this.initialBirthDate,
  }) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  late TextEditingController _studentNameController;
  late String gender;
  late DateTime birthDate;

  @override
  void initState() {
    super.initState();
    _studentNameController = TextEditingController(text: widget.initialStudentName);
    // Kiểm tra nếu giới tính ban đầu là null, đặt giới tính mặc định là "Nam"
    gender = widget.initialGender ?? 'Nam';
    birthDate = widget.initialBirthDate;

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
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Tên sinh viên'),
                  controller: _studentNameController,
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
          onPressed: () {
            // Perform update logic here
            String updatedStudentName = _studentNameController.text;
            String updatedGender = gender;
            DateTime updatedBirthDate = birthDate;

            // Close the dialog and pass updated information back to parent widget
            Navigator.of(context).pop({
              'studentName': updatedStudentName,
              'gender': updatedGender,
              'birthDate': updatedBirthDate,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Change button color to green
            padding: EdgeInsets.all(16.0), // Increase button size
          ),
          child: Text('Cập nhật'),
        ),
      ],
    );
  }
}
