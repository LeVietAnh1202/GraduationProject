import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_student_term.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DtScheduleStudentTerm extends StatefulWidget {
  const DtScheduleStudentTerm({Key? key});

  @override
  State<DtScheduleStudentTerm> createState() => _DtScheduleStudentTermState();
}

class _DtScheduleStudentTermState extends State<DtScheduleStudentTerm> {
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
        .scheduleStudentTerms;
    if (schedules.isEmpty) {
      ScheduleService.fetchScheduleStudentTerms(
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
                        'Tên giảng viên',
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
                  .scheduleStudentTerms
                  .asMap()
                  .entries
                  .map((entry) {
                    final schedule = entry.value;
                    final dateStart = schedule['dateStart'];
                    final dateEnd = schedule['dateEnd'];

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
                        DataCell(Center(child: Text(schedule['lecturerName']))),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoading
                                  ? Container(
                                      child: CircularProgressIndicator(),
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 10),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.library_books),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text(schedule['subjectName']),
                                              content: AttendanceStudentTerm(
                                                  moduleID:
                                                      schedule['moduleID']),
                                              actions: [
                                                TextButton(
                                                  child: Text('Hủy'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                // TextButton(
                                                //   child: Text('Xem'),
                                                //   onPressed: () {
                                                //     // Xử lý logic xóa sinh viên ở hàng tương ứng
                                                //     // deleteStudent(index);
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
