import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/faculties/facultyService.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class DataTableMajor extends StatefulWidget {
  const DataTableMajor({Key? key});

  @override
  State<DataTableMajor> createState() => _DataTableMajorState();
}

class _DataTableMajorState extends State<DataTableMajor> {
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
    // int tableLength = 0;
    // faculties.map((faculty) {
    //   tableLength += faculty.majorNumber;
    // }).toList();
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(faculties.length * rowsPerPage);
  }

  void deleteFaculty(int index) {}

  @override
  Widget build(BuildContext context) {
    int currentPage = context.watch<AppStateProvider>().appState!.currentPage;
    Faculty faculty =
        context.watch<AppStateProvider>().appState!.faculties[currentPage - 1];

    return DataTable(
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              'Mã ngành',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Tên ngành',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Khoa',
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
      rows: faculty.majors.asMap().entries.map((entry) {
        final major = entry.value;
        final index = entry.key;

        return DataRow(
          cells: [
            DataCell(Center(child: Text(major.majorID))),
            DataCell(Center(child: Text(major.majorName))),
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
      // rows: context
      //     .watch<AppStateProvider>()
      //     .appState!
      //     .faculties
      //     .asMap()
      //     .entries
      //     .expand((entry) {
      //   final index = entry.key;
      //   final faculty = entry.value;
      //   final majors = faculty.majors.asMap().entries.map((entry) {
      //     final major = entry.value;

      //     return DataRow(
      //       cells: [
      //         DataCell(Center(child: Text(major.majorID))),
      //         DataCell(Center(child: Text(major.majorName))),
      //         DataCell(Center(child: Text(faculty.facultyName))),
      //         DataCell(
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               IconButton(
      //                 icon: Icon(Icons.edit),
      //                 onPressed: () {
      //                   // Xử lý logic sửa sinh viên ở hàng tương ứng
      //                   // Ví dụ: editStudent(index);
      //                 },
      //               ),
      //               IconButton(
      //                 icon: Icon(Icons.delete),
      //                 onPressed: () {
      //                   showDialog(
      //                     context: context,
      //                     builder: (BuildContext context) {
      //                       return AlertDialog(
      //                         title: Text('Xóa khoa'),
      //                         content:
      //                             Text('Bạn có chắc chắn muốn xóa khoa này?'),
      //                         actions: [
      //                           TextButton(
      //                             child: Text('Hủy'),
      //                             onPressed: () {
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                           TextButton(
      //                             child: Text('Xóa'),
      //                             onPressed: () {
      //                               // Xử lý logic xóa sinh viên ở hàng tương ứng
      //                               deleteFaculty(index);
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                         ],
      //                       );
      //                     },
      //                   );
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //         // Add other cells as needed
      //       ],
      //     );
      //   }).toList();

      //   return majors;
      // }).toList(),
    );
  }
}
