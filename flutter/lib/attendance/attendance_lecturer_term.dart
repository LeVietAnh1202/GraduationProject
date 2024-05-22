import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/detailAttendance.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy tham chiếu tới ThemeData và lưu trữ trong biến thành viên
    _themeData = Theme.of(context);
    // print('widget.moduleID: ' + widget.moduleID);
    // if (widget.moduleID != "") fetchAttendanceLecturerTerms();
  }

  @override
  void initState() {
    super.initState();
    print('init state fetchAttendanceLecturerTerms');
    fetchAttendanceLecturerTerms();
  }

  // @override
  // void dispose() {
  //   // Sử dụng biến thành viên đã lưu trữ thay vì truy cập context
  //   if (_themeData != null) {
  //     // Làm gì đó với _themeData
  //     print('Disposing with theme: $_themeData');
  //   }
  //   super.dispose();
  // }

  void fetchAttendanceLecturerTerms() async {
    print('fetchAttendanceLecturerTerms in attendance_lecturer_term');
    // if (attendances.isEmpty) {
    attendanceLecturerTerms =
        await AttendanceService.fetchAttendanceLecturerTerms(
            context,
            (bool value) => setState(() {
                  _isLoading = value;
                }),
            widget.moduleID);
    // attendances = Provider.of<AppStateProvider>(context, listen: false)
    //     .appState!
    //     .attendanceLecturerTerms;

    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(attendanceLecturerTerms.length);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double widthDataTable = screenWidth - sideBarWidth - 40;
    print('widget.scheduleAdminTermsLength: ' +
        widget.scheduleAdminTermsLength.toString());
    double heightDataTable = screenHeight -
        appBarHeight -
        2 * bodyContentPadding -
        breadcrumbHeight -
        3 * sizeBoxHeight -
        selectHeight -
        dataRowHeight * widget.scheduleAdminTermsLength -
        82;
    print('heightDataTable: ' + heightDataTable.toString());

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
                                          entry["time"],
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
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        DetailAttendance(
                                                            dayID:
                                                                entry['dayID'])
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
                                        child: Utilities.attendanceIcon(
                                            entry.values.first),
                                      ),
                                    ));
                                  }).toList(),
                                  DataCell(Center(
                                      child: Text(
                                          (attendance['numberOfOnTimeSessions'] ==
                                                      0
                                                  ? '-'
                                                  : attendance[
                                                      'numberOfOnTimeSessions'])
                                              .toString()))),
                                  DataCell(Center(
                                      child: Text(
                                          (attendance['numberOfLateSessions'] ==
                                                      0
                                                  ? '-'
                                                  : attendance[
                                                      'numberOfLateSessions'])
                                              .toString()))),
                                  DataCell(Center(
                                      child: Text(
                                          (attendance['numberOfBreaksSessions'] ==
                                                      0
                                                  ? '-'
                                                  : attendance[
                                                      'numberOfBreaksSessions'])
                                              .toString()))),
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
