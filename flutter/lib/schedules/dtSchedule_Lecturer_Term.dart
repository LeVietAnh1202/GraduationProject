import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_lecturer_term.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/export/exxport_attendance_lecturer_term.dart';

import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DtScheduleLecturerTerm extends StatefulWidget {
  const DtScheduleLecturerTerm({Key? key});

  @override
  State<DtScheduleLecturerTerm> createState() => _DtScheduleLecturerTermState();
}

class _DtScheduleLecturerTermState extends State<DtScheduleLecturerTerm> {
  List<Map<String, dynamic>> schedules = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    schedules = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .scheduleLecturerTerms;
    if (schedules.isEmpty) {
      ScheduleService.fetchScheduleLecturerTerms(
          context,
          (bool value) => setState(() {
                _isLoading = value;
              }));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  int scheduleDayComparator(String a, String b) {
    return a.compareTo(b);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
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
                        'Thứ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Tiết',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Mã học phần',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Tên môn',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Số tín chỉ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Phòng học',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Thời gian',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Tên lớp',
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
                  .scheduleLecturerTerms
                  .asMap()
                  .entries
                  .map((entry) {
                    final schedule = entry.value;
                    final dateStart = schedule['dateStart'];
                    final dateEnd = schedule['dateEnd'];

                    print('dateStart: $dateStart');
                    print('dateEnd: $dateEnd');

                    final inputFormat =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                    final outputFormat = DateFormat('dd/MM/yyyy');

                    final formattedStart =
                        outputFormat.format(inputFormat.parse(dateStart));
                    final formattedEnd =
                        outputFormat.format(inputFormat.parse(dateEnd));

                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text(schedule['day']))),
                        DataCell(Center(child: Text(schedule['time']))),
                        DataCell(Center(child: Text(schedule['moduleID']))),
                        DataCell(Center(child: Text(schedule['subjectName']))),
                        DataCell(Center(
                            child:
                                Text(schedule['numberOfCredits'].toString()))),
                        DataCell(Center(child: Text(schedule['roomName']))),
                        DataCell(Center(
                            child:
                                Text('${formattedStart} - ${formattedEnd}'))),
                        DataCell(Center(child: Text(schedule['classCode']))),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.library_books),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(schedule['subjectName']),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text("Lớp: " +
                                                  schedule['classCode']),
                                              SizedBox(height: 20),
                                              AttendanceLecturerTerm(
                                                  moduleID:
                                                      schedule['moduleID']),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Hủy'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          Utilities.exportFileButton(() {
                                            ExportExcel
                                                .exportAttendanceLecturerTermToExcel(
                                                    // context
                                                    //     .watch<
                                                    //         AppStateProvider>()
                                                    //     .appState!
                                                    //     .attendanceLecturerTerms
                                                    Provider.of<AppStateProvider>(
                                                            context,
                                                            listen: false)
                                                        .appState!
                                                        .attendanceLecturerTerms,
                                                    schedule['subjectName'],
                                                    schedule['classCode']);
                                            Navigator.of(context).pop();
                                          }),
                                          // TextButton(
                                          //   style: ElevatedButton.styleFrom(
                                          //     backgroundColor: Colors
                                          //         .green, // Đổi màu xanh cho nút
                                          //     padding: EdgeInsets.all(
                                          //         16.0), // Tăng kích thước của nút
                                          //   ),
                                          //   child: Text(
                                          //     'Xuất file',
                                          //     style: TextStyle(
                                          //         color: Colors.white),
                                          //   ),
                                          //   onPressed: () {
                                          //     ExportExcel
                                          //         .exportAttendanceLecturerTermToExcel(
                                          //             // context
                                          //             //     .watch<
                                          //             //         AppStateProvider>()
                                          //             //     .appState!
                                          //             //     .attendanceLecturerTerms
                                          //             Provider.of<AppStateProvider>(
                                          //                     context,
                                          //                     listen: false)
                                          //                 .appState!
                                          //                 .attendanceLecturerTerms);
                                          //     Navigator.of(context).pop();
                                          //   },
                                          // ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  })
                  .whereType<DataRow>()
                  .toList(growable: false)
                ..sort((a, b) => scheduleDayComparator(
                    ((a.cells[0].child as Center).child as Text)
                        .data
                        .toString(),
                    ((b.cells[0].child as Center).child as Text)
                        .data
                        .toString()))),
    );
  }
}
