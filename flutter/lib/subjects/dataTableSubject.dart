import 'package:flutter/material.dart';
import 'package:flutter_todo_app/lecturers/lecturerService.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DataTableLecturer extends StatefulWidget {
  const DataTableLecturer({Key? key});

  @override
  State<DataTableLecturer> createState() => _DataTableLecturerState();
}

class _DataTableLecturerState extends State<DataTableLecturer> {
  List<Map<String, dynamic>> lecturers = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchLecturers();
    });
  }

  Future<void> fetchLecturers() async {
    try {
      final role =
          Provider.of<AccountProvider>(context, listen: false).getRole();
      final lecturerID =
          Provider.of<AccountProvider>(context, listen: false).getAccount();
      final lecturers = await LecturerService.fetchLecturers(role, lecturerID);

      Provider.of<AppStateProvider>(context, listen: false)
          .setLecturers(lecturers);
    } catch (e) {
      print('Error fetching lecturers: $e');
    }
  }

  void deleteLecturer(int index) {}

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Mã GV',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Họ và tên',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Giới tính',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Ngày sinh',
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
      rows: context
          .watch<AppStateProvider>()
          .appState!
          .lecturers
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final lecturer = entry.value;

        return DataRow(
          cells: [
            DataCell(Center(child: Text(lecturer.lecturerID))),
            DataCell(Center(child: Text(lecturer.lecturerName))),
            DataCell(Center(child: Text(lecturer.gender))),
            DataCell(Center(
              child: Text(DateFormat('dd/MM/yyyy').format(lecturer.birthDate)),
            )),
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
                            title: Text('Xóa giảng viên'),
                            content: Text(
                                'Bạn có chắc chắn muốn xóa giảng viên này?'),
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
                                  deleteLecturer(index);
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
}
