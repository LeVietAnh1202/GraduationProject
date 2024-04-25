import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class FromAddStudent extends StatefulWidget {
  const FromAddStudent({Key? key}) : super(key: key);

  @override
  _FromAddStudentState createState() => _FromAddStudentState();
}

class _FromAddStudentState extends State<FromAddStudent> {
  // Define variables to store the form input values
  TextEditingController _avatarController = TextEditingController();
  TextEditingController _videoController = TextEditingController();
  String? _videoUrl;

  String? _avatarUrl;
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

  Uint8List? _bytesData;
  List<int>? _selectedFile;
  String? fileExtension;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    classCode =
        '10120TN'; // Set the initial value to the first item in the dropdown
    gender = 'Nam'; // Set the initial value to the
  }

  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  List<String> classCodes = [
    '10120TN',
    '101203',
    '101201',
    '101202',
    '101204',
    '101205',
    '125201',
    '125202',
    // Add more class codes as needed
  ];
  //----------------------------------------------------------------

  Future<String> getFileExtension(String fileName) {
    List<String> parts = fileName.split('.');
    if (parts.length > 1) {
      return Future.value(parts.last);
    } else {
      return Future.error('File extension not found');
    }
  }

  Future<void> startFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) async {
        final fe = await getFileExtension(file.name);
        setState(() {
          fileExtension = fe;
          _bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          _selectedFile = _bytesData;
        });
      });
      reader.readAsDataUrl(file);
    });
  }

//----------------------------------------------------------------
  // final String uploadVideoUrl = '';
  // Future<String?> uploadVideoToServer(File file) async {
  //   final response = await http.post(uploadVideoUrl as Uri, body: {
  //     'video': base64Encode(file.readAsBytesSync()),
  //   });

  //   if (response.statusCode == 200) {
  //     final uploadedVideoUrl = response.body;
  //     return uploadedVideoUrl;
  //   } else {
  //     print('Error uploading video: ${response.statusCode}');
  //     return null;
  //   }
  // }

  // void _addStudentVideo() async {
  //   final pickedFile =
  //       await ImagePicker().pickVideo(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final file = File(pickedFile.path);
  //     final uploadedVideoUrl = await uploadVideoToServer(file);
  //     if (uploadedVideoUrl != null) {
  //       setState(() {
  //         _videoUrl = uploadedVideoUrl;
  //         _videoController.text = _videoUrl!;
  //       });
  //     }
  //   }
  // }
// ----------------------------------------------------------------

  Map<String, String> getInforStudent() {
    final studentId = _studentIdController.text;
    final studentName = _studentNameController.text;

    return {
      'studentId': studentId,
      'studentName': studentName,
      'classCode': classCode!,
      'gender': gender!,
      'birthDate': birthDate!.toIso8601String(),
      'avatar': '${studentId}_${studentName}.${fileExtension}',
    };
  }

  Future<void> createStudent(Map<String, String> inforStudent) async {
    final response = await http.post(
      Uri.http(url, createStudentAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inforStudent),
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
      classCode = '10120TN';
      gender = 'Nam';
      birthDate = null;
      _birthDateController.text = '';
      isFormValid = false; // Đặt lại giá trị của isFormValid thành false
      _bytesData = null;
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

  Future uploadImage(Map<String, String> inforStudent) async {
    var request = http.MultipartRequest('POST', Uri.http(url, uploadAvatarAPI));
    request.files.add(await http.MultipartFile.fromBytes(
        'image', _selectedFile!,
        contentType: MediaType('application', 'json'),
        filename: '${inforStudent['avatar']}'));
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
      print('Image URL: ${await response.stream.bytesToString()}');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
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
              Text('Avatar sinh viên'),
              SizedBox(height: 20),
              _bytesData != null
                  ? Image.memory(_bytesData!, height: 200, width: 200)
                  : Image.network(
                      '${ULRNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                      height: 200,
                      width: 200),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await startFilePicker();
                },
                child: Text('Select Image'),
              ),
              SizedBox(height: 10),
              Text('Video sinh viên'),
              GestureDetector(
                // onTap: _addStudentVideo,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library),
                      SizedBox(width: 10),
                      Text('Thêm video'),
                    ],
                  ),
                ),
              ),
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
                    isFormValid =
                        _checkFormValidity(); // Kiểm tra xem các trường đã được điền đầy đủ hay chưa
                  });
                },
                items: classCodes.map((String code) {
                  return DropdownMenuItem(
                    value: code,
                    child: Text(code),
                  );
                }).toList(),
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
              final inforStudent = getInforStudent();
              await createStudent(inforStudent);
              await uploadImage(inforStudent);
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
