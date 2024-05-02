import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class _JsonMap extends MapView<dynamic, dynamic> {
  _JsonMap.fromJson(Map<dynamic, dynamic> json) : super(json);
}

class AttendanceStudentTerm extends StatefulWidget {
  final String moduleID;
  const AttendanceStudentTerm({Key? key, required this.moduleID});

  @override
  State<AttendanceStudentTerm> createState() => _AttendanceStudentTermState();
}

class _AttendanceStudentTermState extends State<AttendanceStudentTerm> {
  Map<String, dynamic> attendances = {};
  // List<String> dateList = ["21/12/2023", "22/12/2023", "23/12/2023"];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    attendances = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .attendanceStudentTerms;
    // attendances =
    //     context.watch<AppStateProvider>().appState!.attendanceStudentTerms;
    // if (attendances.isEmpty) {
    AttendanceService.fetchAttendanceStudentTerms(
        context,
        (bool value) => setState(() {
              _isLoading = value;
            }),
        widget.moduleID);
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  // int vietnameseCollator = Collator('vi');

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    attendances =
        context.watch<AppStateProvider>().appState!.attendanceStudentTerms;
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
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dividerThickness: 2.0, // Độ dày của đường kẻ
                border: TableBorder.all(color: Colors.grey),
                headingRowHeight: 90,
                columns: [
                  ...(context
                          .watch<AppStateProvider>()
                          .appState!
                          .attendanceStudentTerms['dateList'] as List<dynamic>)
                      .map<DataColumn>((entry) {
                    print(entry);
                    print(entry.keys.first);
                    return DataColumn(
                      label: Expanded(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            Utilities.formatDate(entry.keys.first),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Số buổi\nđúng giờ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Số buổi\nđi muộn',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Số buổi\nnghỉ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Add other columns as needed
                ],
                rows: [
                  DataRow(cells: [
                    ...(context
                                .watch<AppStateProvider>()
                                .appState!
                                .attendanceStudentTerms['dateList']
                            as List<dynamic>)
                        .map((entry) {
                      print(entry.values.first);
                      return DataCell(Center(
                        child: Utilities.attendanceIcon(entry.values.first),
                      ));
                    }).toList(),
                    DataCell(Center(
                        child: Text((attendances['numberOfOnTimeSessions'] == 0
                                ? '-'
                                : attendances['numberOfOnTimeSessions'])
                            .toString()))),
                    DataCell(Center(
                        child: Text((attendances['numberOfLateSessions'] == 0
                                ? '-'
                                : attendances['numberOfLateSessions'])
                            .toString()))),
                    DataCell(Center(
                        child: Text((attendances['numberOfBreaksSessions'] == 0
                                ? '-'
                                : attendances['numberOfBreaksSessions'])
                            .toString()))),
                  ])
                ],
              ),
            ));
  }
}
