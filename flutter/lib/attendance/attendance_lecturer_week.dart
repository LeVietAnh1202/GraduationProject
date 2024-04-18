import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class _JsonMap extends MapView<dynamic, dynamic> {
  _JsonMap.fromJson(Map<dynamic, dynamic> json) : super(json);
}

class AttendanceLecturerWeek extends StatefulWidget {
  final String dayID;
  const AttendanceLecturerWeek({Key? key, required this.dayID});

  @override
  State<AttendanceLecturerWeek> createState() => _AttendanceLecturerWeekState();
}

class _AttendanceLecturerWeekState extends State<AttendanceLecturerWeek> {
  Map<String, dynamic> attendances = {};
  // List<String> dateList = ["21/12/2023", "22/12/2023", "23/12/2023"];
  bool _isLoading = true;
  // String selectedWeek = '19'; // Tuần được chọn mặc định

  // void onWeekSelected(String? week) {
  //   setState(() {
  //     selectedWeek = week!;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    print('widget.dayID: ' + widget.dayID);
    attendances = Provider.of<AppStateProvider>(context, listen: false)
        // attendances = context.watch<AppStateProvider>()
        .appState!
        .attendanceLecturerWeeks;
    print('attendances: ');
    print(attendances);
    // if (attendances.isEmpty) {
    AttendanceService.fetchAttendanceLecturerWeeks(
        context,
        (bool value) => setState(() {
              _isLoading = value;
            }),
        widget.dayID);
    print('fetchAttendanceLecturerWeeks');
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   }
    //   );
    // }
  }

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    int index = 0; // Biến đếm số thứ tự
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
                  // decoration: BoxDecoration(
                  //   border:
                  //       Border.all(color: Colors.grey), // Màu sắc của đường kẻ
                  // ),
                  border: TableBorder.all(color: Colors.grey),
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'STT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Họ và tên',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // ...attendances.expand((attendance) {
                    //   print('attendance: ');
                    //   print(attendance);
                    //   return (attendance['dateList']
                    //       as List<Map<String, dynamic>>);
                    // }).map<DataColumn>((date) {
                    //   print('date in datelist: ');
                    //   print(date);
                    //   final dateKey = date.keys.first;
                    //   return DataColumn(
                    //     label: Expanded(
                    //       child: Text(
                    //         dateKey,
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   );
                    // }).toList(),

                    // ...context
                    //     .watch<AppStateProvider>()
                    //     .appState!
                    //     .attendanceLecturerWeeks
                    //     .expand((attendance) {
                    //   print('attendance datacolumn: ');
                    //   print(attendance);
                    //   return (attendance['dateList'] as List<dynamic>)
                    //       .map((entry) {
                    //     print('entry dateList: ');
                    //     print(entry);
                    //     return DataColumn(
                    //       label: Expanded(
                    //         child: Text(
                    //           'abc',
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList();
                    // }),

                    // ...(context
                    //         .watch<AppStateProvider>()
                    //         .appState!
                    //         .attendanceLecturerWeeks
                    //         .first['dateList'] as List<dynamic>)
                    //     .map<DataColumn>((entry) {
                    //   return DataColumn(
                    //     label: Expanded(
                    //       child: RotatedBox(
                    //         quarterTurns: 1,
                    //         child: Text(
                    //           Utilities.formatDate(entry.keys.first),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // }).toList(),

                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Điểm danh',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Số buổi\nđúng giờ',
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Số buổi\nđi muộn',
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Số buổi\nnghỉ',
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),

                    // Add other columns as needed
                  ],
                  rows: ((context
                          .watch<AppStateProvider>()
                          .appState!
                          .attendanceLecturerWeeks['studentAttendance']))
                      .map((entry) {
                        print('entry attendance lecturer week datacell');
                        // print(entry);
                        // final index = entry.keys.first;
                        print(entry);
                        // final studentAttendance = entry.value['studentAttendance'];
                        return DataRow(
                          cells: [
                            DataCell(Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (++index).toString(),
                                textAlign: TextAlign.right,
                              ),
                            )), // Thêm cột số thứ tự
                            DataCell(Text(entry.keys.first)),
                            // ...(attendance['dateList'] as List<dynamic>)
                            //     .map((entry) {
                            //   return DataCell(Center(
                            //     child: Utilities.attendanceIcon(
                            //         entry.values.first),
                            //   ));
                            // }).toList(),
                            DataCell(
                                Utilities.attendanceIcon(entry.values.first)),
                            // DataCell(Center(
                            //     child: Text(
                            //         (entry['numberOfOnTimeSessions'] == 0
                            //                 ? '-'
                            //                 : entry['numberOfOnTimeSessions'])
                            //             .toString()))),
                            // DataCell(Center(
                            //     child: Text((entry['numberOfLateSessions'] == 0
                            //             ? '-'
                            //             : entry['numberOfLateSessions'])
                            //         .toString()))),
                            // DataCell(Center(
                            //     child: Text(
                            //         (entry['numberOfBreaksSessions'] == 0
                            //                 ? '-'
                            //                 : entry['numberOfBreaksSessions'])
                            //             .toString()))),
                          ],
                        );
                      })
                      .whereType<DataRow>()
                      .toList(growable: false)

                  // ..sort((a, b) => (
                  //     ((a.cells[0].child as Center).child as Text)
                  //         .data
                  //         .toString(),
                  //     ((b.cells[0].child as Center).child as Text)
                  //         .data
                  //         .toString()
                  //         )
                  ),
            ),
          );
  }
}
