import 'package:flutter/material.dart';
import 'package:flutter_todo_app/faculties/facultyService.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class DataTableFaculty extends StatefulWidget {
  const DataTableFaculty({Key? key});

  @override
  State<DataTableFaculty> createState() => _DataTableFacultyState();
}

class _DataTableFacultyState extends State<DataTableFaculty> {
  List<Map<String, dynamic>> lecturers = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchFaculties(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
  }

  Future<void> fetchFaculties() async {
    final faculties =
        await FacultyService.fetchFaculties(context, (value) => {});
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(faculties.length);
  }

  void deleteFaculty(int index) {}

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Mã khoa',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Tên khoa',
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
          .faculties
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final faculty = entry.value;
        print(entry.value);

        return DataRow(
          cells: [
            DataCell(Center(child: Text(faculty.facultyID))),
            DataCell(Center(child: Text(faculty.facultyName))),
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
                            title: Text('Xóa khoa'),
                            content:
                                Text('Bạn có chắc chắn muốn xóa khoa này?'),
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
                                  deleteFaculty(index);
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
