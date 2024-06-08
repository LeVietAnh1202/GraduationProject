import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/detailAttendance.dart';
import 'package:flutter_todo_app/attendance/detail_attendance_student_day.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/export/export_attendance_lecturer.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class _JsonMap extends MapView<dynamic, dynamic> {
  _JsonMap.fromJson(Map<dynamic, dynamic> json) : super(json);
}

class AttendanceLecturerTerm extends StatefulWidget {
  final String moduleID;
  final int scheduleAdminTermsLength;
  const AttendanceLecturerTerm(
      {Key? key,
      required this.moduleID,
      required this.scheduleAdminTermsLength});

  @override
  State<AttendanceLecturerTerm> createState() => _AttendanceLecturerTermState();
}

class _AttendanceLecturerTermState extends State<AttendanceLecturerTerm> {
  List<dynamic> attendanceLecturerTerms = [];
  bool _isLoading = true;

  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchAttendanceLecturerTerms();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy tham chiếu tới ThemeData và lưu trữ trong biến thành viên
    _themeData = Theme.of(context);
    // if (widget.moduleID != "") fetchAttendanceLecturerTerms();
  }

  @override
  void didUpdateWidget(covariant AttendanceLecturerTerm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.moduleID != oldWidget.moduleID) {
      fetchAttendanceLecturerTerms();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchAttendanceLecturerTerms() async {
    setState(() {
      _isLoading = true;
    });
    attendanceLecturerTerms =
        await AttendanceService.fetchAttendanceLecturerTerms(
            context,
            (bool value) => setState(() {
                  _isLoading = value;
                }),
            widget.moduleID);
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(attendanceLecturerTerms.length);
  }

  @override
  Widget build(BuildContext context) {
    final studentId =
        Provider.of<AccountProvider>(context, listen: false).account!.account;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double widthDataTable = screenWidth - sideBarWidth - 40;
    double heightDataTable = screenHeight -
        appBarHeight -
        2 * bodyContentPadding -
        breadcrumbHeight -
        3 * sizeBoxHeight -
        selectHeight -
        dataRowHeight * widget.scheduleAdminTermsLength -
        140;

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
        : Center(
            child: Container(
              width: widthDataTable,
              height: heightDataTable,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
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
                        headingRowHeight: 75,
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

                          // ...(context
                          //         .watch<AppStateProvider>()
                          //         .appState!
                          //         .attendanceLecturerTerms
                          //         .first['dateList'] as List<dynamic>)
                          //     .map<DataColumn>((entry) {
                          //   return DataColumn(
                          //     label: Expanded(
                          //       child: RotatedBox(
                          //         quarterTurns: 1,
                          //         child: Text(
                          //           Utilities.formatDate(entry.keys.first),
                          //           textAlign: TextAlign.center,
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //     ),
                          //   );
                          // }).toList(),
                          ...(context
                                  .watch<AppStateProvider>()
                                  .appState!
                                  .attendanceLecturerTerms
                                  .first['dateList'] as List<dynamic>)
                              .map<DataColumn>((entry) {
                            print('entry');
                            print(entry);
                            return DataColumn(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          entry[entry.keys.first]["time"],
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
                                                  // title: Text(
                                                  //     'Chi tiết điểm danh cho ngày ${Utilities.formatDate(entry.keys.first)}.'),
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          'Chi tiết điểm danh cho ngày ${Utilities.formatDate(entry.keys.first)}.'),
                                                      // IconButton(
                                                      //   icon: Icon(Icons
                                                      //       .file_download),
                                                      //   onPressed: () async {
                                                      //     final attendance =
                                                      //         Provider.of<AppStateProvider>(
                                                      //                 context,
                                                      //                 listen:
                                                      //                     false)
                                                      //             .appState!
                                                      //             .attendanceLecturerTerms;
                                                      //     await ExportExcel
                                                      //         .exportAttendanceLecturerWeekToExcel(
                                                      //             attendance,
                                                      //             subjectName,
                                                      //             '10120TN'
                                                      //             );
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        DetailAttendance(
                                                            dayID: entry[entry
                                                                    .keys.first]
                                                                ['dayID'])
                                                        // DetailAttendanceStudentDayWidget(
                                                        //   studentId: studentId,
                                                        //   dayID: entry[entry
                                                        //       .keys
                                                        //       .first]['dayID'],
                                                        // )
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
                                  // ...(attendance['dateList'] as List<dynamic>)
                                  //     .map((entry) {
                                  //   return DataCell(Center(
                                  //     child: Utilities.attendanceIcon(
                                  //         entry.values.first),
                                  //   ));
                                  // }).toList(),
                                  ...(attendance['dateList'] as List<dynamic>)
                                      .map((entry) {
                                    return DataCell(Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Utilities.attendanceImages(
                                            entry[entry.keys.first]
                                                ['NoImages']),
                                      ),
                                    ));
                                  }).toList(),
                                  DataCell(Center(
                                      child: Text(
                                          '${(attendance['NoImagesValid'] == 0 ? '-' : attendance['NoImagesValid']).toString()}/${attendance['numberOfLessons']}'))),
                                ],
                              );
                            })
                            .whereType<DataRow>()
                            .toList(growable: false)),
                  ),
                ),
              ),
            ),
          );
  }
}
