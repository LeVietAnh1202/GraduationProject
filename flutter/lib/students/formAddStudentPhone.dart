import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_todo_app/classes/classService.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/faculties/facultyService.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FromAddStudent extends StatefulWidget {
  const FromAddStudent({Key? key}) : super(key: key);

  @override
  _FromAddStudentState createState() => _FromAddStudentState();
}

class _FromAddStudentState extends State<FromAddStudent> {
  String? studentId;
  TextEditingController _studentIdController = TextEditingController();
  String? studentName;
  TextEditingController _studentNameController = TextEditingController();
  String? classCode;
  String? specializationID;
  String? gender;
  DateTime? birthDate;
  TextEditingController _birthDateController = TextEditingController();
  bool isAddingStudentSuccess = false;
  bool isFormValid = false;
  bool isLoading = false;
  bool isLoadingClassCode = true;
  bool isLoadingFaculty = true;

  Uint8List? _bytesImage;
  Uint8List? _bytesVideo;
  List<int>? _selectedImage;
  List<int>? _selectedVideo;
  String? imageExtension;
  String? videoExtension;
  late String fileVideoName = '';

  late List<Faculty> faculties;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    classCode = '10120TN';
    gender = 'Nam';
    Future.delayed(Duration.zero, () {
      fetchClasses();
      fetchSpecializationIDs();
    });
  }

  Future<void> fetchClasses() async {
    final classes = await ClassService.fetchClasses(context, (value) {
      setState(() {
        isLoadingClassCode = value;
      });
    });
  }

  Future<void> fetchSpecializationIDs() async {
    faculties = await FacultyService.fetchFaculties(context, (value) {
      setState(() {
        isLoadingFaculty = value;
      });
    });
    specializationID =
        faculties[0].majors[0].specializations[0].specializationID;
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final extension = pickedFile.path.split('.').last;
      setState(() {
        _bytesImage = bytes;
        _selectedImage = bytes;
        imageExtension = extension;
      });
    }
  }

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final extension = pickedFile.path.split('.').last;
      setState(() {
        _bytesVideo = bytes;
        _selectedVideo = bytes;
        videoExtension = extension;
        fileVideoName = pickedFile.name;
      });
    }
  }

  Map<String, String> getInforStudent() {
    final studentId = _studentIdController.text;
    final studentName = _studentNameController.text;

    return {
      'studentId': studentId,
      'studentName': studentName,
      'classCode': classCode!,
      'specializationID': specializationID!,
      'gender': gender!,
      'birthDate': birthDate!.toIso8601String(),
      'avatar': '${studentId}_${studentName}.${imageExtension}',
      'video': '${studentId}_${studentName}.${videoExtension}',
    };
  }

  Future<void> createStudent(Map<String, String> inforStudent) async {
    final response =
        json.decode(await StudentService.createStudent(inforStudent));
    if (response['statusCode'] == 200) {
      StudentService.fetchStudents(context, (value) => {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.green,
        ),
      );

      clearForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${response['message']}: ${response['statusCode']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clearForm() {
    setState(() {
      studentId = null;
      _studentIdController.text = '';
      studentName = null;
      _studentNameController.text = '';
      classCode = '10120TN';
      specializationID =
          faculties[0].majors[0].specializations[0].specializationID;
      gender = 'Nam';
      birthDate = null;
      _birthDateController.text = '';
      isFormValid = false;
      _bytesImage = null;
      fileVideoName = '';
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

  Future<void> uploadImage(Map<String, String> inforStudent) async {
    var request = http.MultipartRequest('POST', Uri.http(url, uploadAvatarAPI));
    request.files.add(await http.MultipartFile.fromBytes(
        'image', _selectedImage!,
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

  Future<void> uploadVideo(Map<String, String> inforStudent) async {
    var request = http.MultipartRequest('POST', Uri.http(url, uploadVideoAPI));
    request.files.add(await http.MultipartFile.fromBytes(
        'video', _selectedVideo!,
        contentType: MediaType('application', 'json'),
        filename: '${inforStudent['video']}'));
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Video uploaded successfully!');
      print('Video URL: ${await response.stream.bytesToString()}');
    } else {
      print('Failed to upload video. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm sinh viên'),
      content: (isLoadingClassCode || isLoadingFaculty)
          ? Center(
              child: Container(
                  width: 15, height: 15, child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Mã sinh viên'),
                        controller: _studentIdController,
                        onChanged: (value) {
                          setState(() {
                            studentId = value;
                            isFormValid = _checkFormValidity();
                          });
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Tên sinh viên'),
                        controller: _studentNameController,
                        onChanged: (value) {
                          setState(() {
                            studentName = value;
                            isFormValid = _checkFormValidity();
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Mã lớp'),
                        value: classCode,
                        onChanged: (value) {
                          setState(() {
                            classCode = value;
                            isFormValid = _checkFormValidity();
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
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  birthDate = date;
                                  _birthDateController.text =
                                      DateFormat('dd/MM/yyyy').format(date);
                                  isFormValid = _checkFormValidity();
                                });
                              }
                            },
                          ),
                        ),
                        readOnly: true,
                        controller: _birthDateController,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            InputDecoration(labelText: 'Chuyên ngành'),
                        value: specializationID,
                        onChanged: (value) {
                          setState(() {
                            specializationID = value;
                            isFormValid = _checkFormValidity();
                          });
                        },
                        items: context
                            .watch<AppStateProvider>()
                            .appState!
                            .faculties[0]
                            .majors
                            .asMap()
                            .entries
                            .expand((entry) {
                          final major = entry.value;
                          final specialization =
                              major.specializations.asMap().entries.map((e) {
                            final specialization = e.value;
                            return DropdownMenuItem(
                              value: specialization.specializationID,
                              child:
                                  Text(specialization.specializationName),
                            );
                          }).toList();
                          return specialization;
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text('Thêm ảnh của sinh viên'),
                      SizedBox(height: 10),
                      _bytesImage != null
                          ? Image.memory(_bytesImage!, height: 200, width: 200)
                          : Image.network(
                              '${URLNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: Text('Chọn ảnh đại diện'),
                      ),
                      SizedBox(height: 20),
                      Text('Thêm video sinh viên'),
                      SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: pickVideo,
                              child: Text('Chọn video'),
                            ),
                            SizedBox(width: 20),
                            isLoading
                                ? CircularProgressIndicator()
                                : fileVideoName != ''
                                    ? Text(fileVideoName,
                                        style: TextStyle(fontSize: 14))
                                    : Text(
                                        'Không có tệp tin video nào được chọn',
                                        style: TextStyle(fontSize: 14),
                                      ),
                          ],
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
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: EdgeInsets.all(16.0),
          ),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (isFormValid) {
              final inforStudent = getInforStudent();
              await createStudent(inforStudent);
              await uploadImage(inforStudent);
              await uploadVideo(inforStudent);
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
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(16.0),
          ),
          child: Text('Thêm'),
        ),
      ],
    );
  }
}
