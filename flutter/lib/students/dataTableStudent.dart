import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/students/detailStudent.dart';
import 'package:flutter_todo_app/students/formAddStudent.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DataTableStudent extends StatefulWidget {
  DataTableStudent({Key? key});

  @override
  State<DataTableStudent> createState() => _DataTableStudentState();
}

class _DataTableStudentState extends State<DataTableStudent> {
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchStudents(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
  }

  void fetchStudents() async {
    int student_length =
        await StudentService.fetchStudents(context, (value) => {})
            .then((value) => value.length);
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(student_length);
  }

  void deleteStudent(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    bool isHovering = false;
    int currentPage = context.watch<AppStateProvider>().appState!.currentPage;
    int rowsPerPage = context.watch<AppStateProvider>().appState!.rowsPerPage;

    // Get the student list from AppStateProvider
    // List<Map<String, dynamic>> students =
    List<Student> students =
        context.watch<AppStateProvider>().appState!.students;

    // Calculate the start and end index of the current page
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    endIndex = endIndex > students.length ? students.length : endIndex;

    // Get the student list for the current page
    // List<Map<String, dynamic>> currentPageStudents =
    List<Student> currentPageStudents = students.sublist(startIndex, endIndex);

    print('currentPageStudents: ');
    print(currentPageStudents);

    double iconSize = 20;

    return DataTable(
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Avatar',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'ID',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Full Name',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Class code',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Gender',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Birth date',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Actions',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Add other columns as needed
      ],
      rows: currentPageStudents.asMap().entries.map((entry) {
        final index = entry.key;
        final student = entry.value;

        return DataRow(
          cells: [
            DataCell(
              Center(
                child: ClipOval(
                  child: Image.network(
                    '${ULRNodeJSServer_RaspberryPi_Images}/avatar/${student.avatar}',
                    width: 45, // Điều chỉnh chiều rộng nếu cần
                    height: 45, // Điều chỉnh chiều cao nếu cần
                    fit: BoxFit.cover,
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
                        '${ULRNodeJSServer}/images/avatar/avatar.jpg',
                        width: 150, // Điều chỉnh chiều rộng nếu cần
                        height: 150, // Điều chỉnh chiều cao nếu cần
                      );
                    },
                  ),
                ),
              ),
            ),

            DataCell(Center(child: Text(student.studentId))),
            DataCell(Text(
              student.studentName,
              textAlign: TextAlign.left,
            )),
            DataCell(Text(
              student.classCode,
              textAlign: TextAlign.left,
            )),
            DataCell(Center(child: Text(student.gender))),
            DataCell(Center(
              child: Text(DateFormat('dd/MM/yyyy').format(student.birthDate)),
            )),
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye_outlined),
                    iconSize: iconSize,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DetailStudent(
                              studentId: student.studentId,
                            );
                          });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: iconSize,
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    iconSize: iconSize,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Hiển thị'),
                            content: Text(
                                'Bạn có chắc chắn muốn xóa sinh viên này?'),
                            actions: [
                              TextButton(
                                child: Text('Hủy'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Xóa'),
                                onPressed: () {
                                  // Xử lý logic xóa sinh viên ở hàng tương ứng
                                  deleteStudent(index);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // Add other cells as needed
          ],
        );
      }).toList(),
    );
  }

  IconButton acctionButton(void Function()? onPressed, Widget icon) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }
}
