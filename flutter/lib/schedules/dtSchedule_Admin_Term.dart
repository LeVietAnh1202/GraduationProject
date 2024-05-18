import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_student_term.dart';
import 'package:flutter_todo_app/model/scheduleAdminTermModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:flutter_todo_app/students/dataTableStudentbyModule.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DtScheduleAdminTerm extends StatefulWidget {
  String lecturerID;
  String subjectID;
  String semesterID;
  DtScheduleAdminTerm(
      {Key? key,
      required this.lecturerID,
      required this.subjectID,
      required this.semesterID});

  @override
  State<DtScheduleAdminTerm> createState() => _DtScheduleAdminTermState();
}

class _DtScheduleAdminTermState extends State<DtScheduleAdminTerm> {
  List<ScheduleAdminTerm> scheduleAdminTerms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchScheduleAdminTerms(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
    print(
        'initState DtScheduleAdminTerm ${widget.lecturerID}, ${widget.semesterID}, ${widget.subjectID}');
  }

  Future<void> fetchScheduleAdminTerms() async {
    final scheduleAdminTerms =
        await ScheduleService.fetchScheduleAdminTerms(context, (bool value) {
      setState(() {
        _isLoading = value;
      });
    }, widget.lecturerID, widget.subjectID, widget.semesterID);
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(scheduleAdminTerms.length);
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
    // fetchScheduleAdminTerms();
    print(
        'DtScheduleAdminTerm ${widget.lecturerID}, ${widget.semesterID}, ${widget.subjectID}');
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
                  .scheduleAdminTerms
                  .asMap()
                  .entries
                  .map((entry) {
                    final schedule = entry.value;
                    final dateStart = schedule.dateStart;
                    final dateEnd = schedule.dateEnd;

                    // final inputFormat =
                    //     DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                    final outputFormat = DateFormat('dd/MM/yyyy');

                    final formattedStart = outputFormat.format(dateStart);
                    final formattedEnd = outputFormat.format(dateEnd);

                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text(schedule.day))),
                        DataCell(Center(child: Text(schedule.time))),
                        DataCell(Center(child: Text(schedule.moduleID))),
                        DataCell(Center(child: Text(schedule.subjectName))),
                        DataCell(Center(
                            child: Text(schedule.numberOfCredits.toString()))),
                        DataCell(Center(child: Text(schedule.roomName))),
                        DataCell(Center(
                            child:
                                Text('${formattedStart} - ${formattedEnd}'))),
                        DataCell(Center(child: Text(schedule.lecturerName))),
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
                                              title: Text(schedule.subjectName),
                                              content: DataTableStudentByModule(
                                                  moduleID: schedule.moduleID),
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
