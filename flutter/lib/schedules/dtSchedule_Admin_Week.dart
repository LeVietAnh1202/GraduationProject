import 'package:flutter/material.dart';

import 'package:flutter_todo_app/schedules/scheduleService.dart';

class DtScheduleAdminWeek extends StatefulWidget {
  const DtScheduleAdminWeek({Key? key});

  @override
  State<DtScheduleAdminWeek> createState() => _DtScheduleAdminWeekState();
}

class _DtScheduleAdminWeekState extends State<DtScheduleAdminWeek> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    ScheduleService.fetchStudents(context);
  }

  // Future<void> fetchStudents() async {
  //   final response = await http.get(Uri.http(url, getAllStudentAPI));

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     final studentList = data['data'] as List<dynamic>;
  //     print("Student list: " + studentList.toString());

  //     // setState(() {
  //     //   students = studentList.cast<Map<String, dynamic>>();
  //     // });

  //     Provider.of<AppStateProvider>(context, listen: false)
  //         .setStudents(studentList.cast<Map<String, dynamic>>());
  //   } else {
  //     throw Exception('Failed to fetch students');
  //   }
  // }

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Thứ',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'STT',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Mã học phần',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Tên môn',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Thời gian học',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Phòng học',
              textAlign: TextAlign.center,
            ),
          ),
        ),

        DataColumn(
          label: Expanded(
            child: Text(
              'Tác vụ',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Add other columns as needed
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Center(child: Text("2"))),
            DataCell(Center(child: Text("31111114"))),
            DataCell(Center(child: Text("20000001"))),
            DataCell(Center(child: Text("Môn 1"))),
            DataCell(Center(child: Text("1-4"))),
            DataCell(Center(child: Text("P302"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
        DataRow(
          cells: [
            DataCell(Center(child: Text("3"))),
            DataCell(Center(child: Text("31111114"))),
            DataCell(Center(child: Text("20000001"))),
            DataCell(Center(child: Text("Môn 1"))),

            DataCell(Center(child: Text("1-5"))),
            DataCell(Center(child: Text("P302"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
        DataRow(
          cells: [
            DataCell(Center(child: Text("3"))),
            DataCell(Center(child: Text("31111115"))),
            DataCell(Center(child: Text("20000002"))),
            DataCell(Center(child: Text("Môn 1"))),

            DataCell(Center(child: Text("9-11"))),
            DataCell(Center(child: Text("P503"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
        DataRow(
          cells: [
            DataCell(Center(child: Text("5"))),
            DataCell(Center(child: Text("31111112"))),
            DataCell(Center(child: Text("20000004"))),
            DataCell(Center(child: Text("Môn 1"))),

            DataCell(Center(child: Text("2-5"))),
            DataCell(Center(child: Text("P304"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
        DataRow(
          cells: [
            DataCell(Center(child: Text("6"))),
            DataCell(Center(child: Text("31111113"))),
            DataCell(Center(child: Text("20000002"))),
            DataCell(Center(child: Text("Môn 1"))),

            DataCell(Center(child: Text("8-11"))),
            DataCell(Center(child: Text("P206"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
        DataRow(
          cells: [
            DataCell(Center(child: Text("6"))),
            DataCell(Center(child: Text("31111112"))),
            DataCell(Center(child: Text("20000001"))),
            DataCell(Center(child: Text("Môn 1"))),

            DataCell(Center(child: Text("9-11"))),
            DataCell(Center(child: Text("P503"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
        DataRow(
          cells: [
            DataCell(Center(child: Text("7"))),
            DataCell(Center(child: Text("31111118"))),
            DataCell(Center(child: Text("20000003"))),
            DataCell(Center(child: Text("Môn 1"))),

            DataCell(Center(child: Text("1-4"))),
            DataCell(Center(child: Text("P208"))),

            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Xử lý logic sửa sinh viên ở hàng tương ứng
                      // Ví dụ: editStudent(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xóa sinh viên'),
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
                                  // deleteSchedule(index);
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
        ),
      ],
    );
  }
}
