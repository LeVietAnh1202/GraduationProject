import 'package:flutter/material.dart';
import 'package:flutter_todo_app/faculties/facultyService.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class DataTableFaculty extends StatefulWidget {
  const DataTableFaculty({Key? key});

  @override
  State<DataTableFaculty> createState() => _DataTableFacultyState();
}

class _DataTableFacultyState extends State<DataTableFaculty> {
  List<Faculty> _faculties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchFaculties();
    });
  }

  Future<void> fetchFaculties() async {
    setState(() {
      _isLoading = true;
    });
    final tmp = await FacultyService.fetchFaculties(context, (value) {
      setState(() {
        _isLoading = value;
      });
    });
    setState(() {
      _faculties = tmp;
    });
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(_faculties.length);
  }

  void deleteFaculty(int index) {}

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            child: Container(
              child: CircularProgressIndicator(),
              margin: EdgeInsets.only(bottom: 5, top: 10),
            ),
          )
        : DataTable(
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
            ],
            rows: _faculties
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final faculty = entry.value;

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
                                  content: Text(
                                      'Bạn có chắc chắn muốn xóa khoa này?'),
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
