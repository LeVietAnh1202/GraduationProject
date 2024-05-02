import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class _JsonMap extends MapView<dynamic, dynamic> {
  _JsonMap.fromJson(Map<dynamic, dynamic> json) : super(json);
}

class AttendanceLecturerTerm extends StatefulWidget {
  final String moduleID;
  const AttendanceLecturerTerm({Key? key, required this.moduleID});

  @override
  State<AttendanceLecturerTerm> createState() => _AttendanceLecturerTermState();
}

class _AttendanceLecturerTermState extends State<AttendanceLecturerTerm> {
  List<Map<String, dynamic>> attendances = [];
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
    attendances = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .attendanceLecturerTerms;
    // if (attendances.isEmpty) {
    AttendanceService.fetchAttendanceLecturerTerms(
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
    return _isLoading
        ? Container(
            // zzzzz: Alignment.center,
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
                  headingRowHeight: 90,
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
                    //     .attendanceLecturerTerms
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

                    ...(context
                            .watch<AppStateProvider>()
                            .appState!
                            .attendanceLecturerTerms
                            .first['dateList'] as List<dynamic>)
                        .map<DataColumn>((entry) {
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
                  rows: context
                      .watch<AppStateProvider>()
                      .appState!
                      .attendanceLecturerTerms
                      .asMap()
                      .entries
                      .map((entry) {
                        final index = entry.key;
                        final attendance = entry.value;
                        print('attendance datacell: ');
                        print(attendance);
                        // final dateStart = schedule['dateStart'];
                        // final dateEnd = schedule['dateEnd'];

                        // print('dateStart: $dateStart');
                        // print('dateEnd: $dateEnd');

                        // final inputFormat =
                        //     DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                        // final outputFormat = DateFormat('dd/MM/yyyy');

                        // final formattedStart =
                        //     outputFormat.format(inputFormat.parse(dateStart));
                        // final formattedEnd =
                        //     outputFormat.format(inputFormat.parse(dateEnd));

                        return DataRow(
                          cells: [
                            DataCell(Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (index + 1).toString(),
                                textAlign: TextAlign.right,
                              ),
                            )), // Thêm cột số thứ tự
                            DataCell(Text(attendance['studentName'])),
                            ...(attendance['dateList'] as List<dynamic>)
                                .map((entry) {
                              return DataCell(Center(
                                child: Utilities.attendanceIcon(
                                    entry.values.first),
                              ));
                            }).toList(),
                            DataCell(Center(
                                child: Text(
                                    (attendance['numberOfOnTimeSessions'] == 0
                                            ? '-'
                                            : attendance[
                                                'numberOfOnTimeSessions'])
                                        .toString()))),
                            DataCell(Center(
                                child: Text(
                                    (attendance['numberOfLateSessions'] == 0
                                            ? '-'
                                            : attendance[
                                                'numberOfLateSessions'])
                                        .toString()))),
                            DataCell(Center(
                                child: Text(
                                    (attendance['numberOfBreaksSessions'] == 0
                                            ? '-'
                                            : attendance[
                                                'numberOfBreaksSessions'])
                                        .toString()))),
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
