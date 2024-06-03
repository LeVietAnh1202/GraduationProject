import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/detail_attendance_student_day.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/model/moduleTermByLecturerIDModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

// ignore: unused_element
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
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchAttendanceStudentTerms();
    });
  }

  void fetchAttendanceStudentTerms() async {
    setState(() {
      _isLoading = true;
    });
    attendances = await AttendanceService.fetchAttendanceStudentTerms(
        context,
        (bool value) => setState(() {
              _isLoading = value;
            }),
        widget.moduleID);
  }

  @override
  void didUpdateWidget(covariant AttendanceStudentTerm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.moduleID != oldWidget.moduleID) {
      fetchAttendanceStudentTerms();
    }
  }

  // int vietnameseCollator = Collator('vi');

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double widthDataTable = screenWidth - sideBarWidth - 40;
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
        : Container(
            // width: widthDataTable,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
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
                                    .attendanceStudentTerms['dateList']
                                as List<dynamic>)
                            .map<DataColumn>((entry) {
                          print('check time');
                          print(entry);
                          final date = entry.keys.first;
                          final value = entry[date];
                          return
                              // DataColumn(
                              //   label: Expanded(
                              //     child: RotatedBox(
                              //       quarterTurns: 0,
                              //       child: Text(
                              //         Utilities.formatDate(entry.keys.first),
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(fontWeight: FontWeight.bold),
                              //       ),
                              //     ),
                              //   ),
                              // );
                              DataColumn(
                            label: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  RotatedBox(
                                    quarterTurns: 0,
                                    child: Text(
                                      Utilities.formatDate(entry.keys.first),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          // fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        value["time"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            // fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Chi tiết điểm danh cho ngày ${Utilities.formatDate(entry.keys.first)}.'),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      // DetailAttendanceStudentDayWidget()
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Đóng'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey[600],
                                          // size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Số ảnh/Tổng số tiết',
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
                            final date = entry.keys.first;
                            final value = entry[date];
                            // final attendance = entry.value;
                            return DataCell(Center(
                              child:
                                  Utilities.attendanceImages(value['NoImages']),
                            ));
                          }).toList(),
                          DataCell(Center(
                              child: Text(
                                  '${(attendances['NoImagesValid'] == 0 ? '-' : attendances['NoImagesValid']).toString()}/${attendances['numberOfLessons']}'))),
                        ])
                      ],
                    ),
                  )),
            ),
          );
  }
}
