import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/singleChoice.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailStudent extends StatefulWidget {
  final String studentId; // Thêm trường studentId
  const DetailStudent({Key? key, required this.studentId});

  @override
  State<DetailStudent> createState() => _DetailStudentState();
}

class _DetailStudentState extends State<DetailStudent> {
  List<Student> students = [];
  // List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AppStateProvider>(context, listen: false)
        .setCalendarView(Calendar.week);
    // Gọi hàm fetchStudents để tải dữ liệu sinh viên
    StudentService.fetchStudents(context, (value) {
      // if (value != null) {
      //   // // Nếu dữ liệu không phải null, gán vào biến students và gọi setState để rebuild widget
      //   // setState(() {
      //   //   students = value as List<Map<String, dynamic>>;
      //   // });
      // } else {
      //   // Xử lý khi dữ liệu trả về từ fetchStudents là null
      //   // Ví dụ: hiển thị thông báo lỗi
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text('Error'),
      //       content: Text('Failed to load student data.'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text('OK'),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100, // Độ rộng cố định cho nhãn
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tìm sinh viên có studentId tương ứng trong danh sách students đã tải
    // Map<String, dynamic> defaultStudent = {
    //   'studentId': '',
    //   'studentName': '',
    //   'classCode': '',
    //   'gender': '',
    //   'birthDate': '',
    // };
    final defaultStudent = Student.fromMap({});
    final students = context.watch<AppStateProvider>().appState!.students;
    final student = students.firstWhere(
    // Map<String, dynamic> student = students.firstWhere(
      (student) => student.studentId == widget.studentId,
      orElse: () => defaultStudent,
    );

    return AlertDialog(
      title: Text('Detail student'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('ID:', student.studentId),
                      _buildInfoRow('Full name:', student.studentName),
                      _buildInfoRow('Class code:', student.classCode),
                      _buildInfoRow('Gender:', student.gender),
                      _buildInfoRow(
                        'Birth date:',
                        DateFormat('dd/MM/yyyy').format(student.birthDate),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  child: Image.network(
                    '${ULRNodeJSServer_RaspberryPi_Images}/avatar/${student.avatar}',
                    width: 150,
                    height: 150,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.network(
                        '${ULRNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                        width: 150,
                        height: 150,
                      );
                    },
                  ),
                ),
                // Container(
                //   child: FutureBuilder<void>(
                //     future: _loadImage(student),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       } else if (snapshot.connectionState ==
                //           ConnectionState.done) {
                //         if (snapshot.hasError) {
                //           // Xử lý khi gặp lỗi
                //           return Image.network(
                //             '${ULRNodeJSServer}/images/avatar/avatar.jpg',
                //             width: 150,
                //             height: 150,
                //           );
                //         } else {
                //           // Xử lý khi tải hình ảnh thành công
                //           return Image.network(
                //             '${ULRNodeJSServer}/images/avatar/${student['avatar']}',
                //             width: 150,
                //             height: 150,
                //           );
                //         }
                //       } else {
                //         return SizedBox(); // Trả về một widget trống nếu không thể xác định trạng thái
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
            SingleChoice(option: SegmentButtonOption.image),
            SizedBox(height: 30),
            SizedBox(
              height: 450,
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 200,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: [
                      Image.network(
                        '${ULRNodeJSServer_RaspberryPi_Images}/${(Provider.of<AppStateProvider>(context, listen: false).appState?.imagesView) == ShowImage.full ? 'full_images' : 'crop_images'}/${student.avatar.toString().substring(0, student.avatar.toString().indexOf('.'))}/${1}.jpg',
                        width: 131,
                        height: 131,
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.network(
                        '${ULRNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                        width: 131,
                        height: 131,
                      );
                    },
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Image ' + (index + 1).toString(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ]),
                  );
                },
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
