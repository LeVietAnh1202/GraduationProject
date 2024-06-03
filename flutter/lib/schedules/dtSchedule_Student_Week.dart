import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_student_term.dart';
import 'package:flutter_todo_app/attendance/detail_attendance_student_day.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DtScheduleStudentWeek extends StatefulWidget {
  // final ValueChanged<bool> haveContentFunc;
  const DtScheduleStudentWeek({
    Key? key,
    // required this.haveContentFunc
  });

  @override
  State<DtScheduleStudentWeek> createState() => _DtScheduleStudentWeekState();
}

class _DtScheduleStudentWeekState extends State<DtScheduleStudentWeek> {
  List<Map<String, dynamic>> schedules = [];
  String selectedWeek = '19'; // Tuần được chọn mặc định
  bool _isLoading = true;

  void _onWeekSelected(String? week) {
    setState(() {
      selectedWeek = week!;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);
    schedules = appStateProvider.appState!.scheduleStudentWeeks;
    if (schedules.isEmpty) {
      await ScheduleService.fetchScheduleStudentWeeks(
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

  Widget _buildWeekDropdown(BuildContext context) {
    final List<String> weeks = [
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
    ]; // Danh sách tuần

    schedules =
        context.watch<AppStateProvider>().appState!.scheduleStudentWeeks;

    return DropdownButton<String>(
      value: selectedWeek,
      onChanged: _onWeekSelected,
      items: weeks
          .map((week) {
            final schedule = schedules.firstWhere(
              (schedule) => schedule['week'] == week,
              orElse: () => {'weekTimeStart': '', 'weekTimeEnd': ''},
            );
            final weekTimeStart = schedule['weekTimeStart'];
            final weekTimeEnd = schedule['weekTimeEnd'];

            if (weekTimeStart.isNotEmpty && weekTimeEnd.isNotEmpty) {
              final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
              final outputFormat = DateFormat('dd/MM/yyyy');

              final formattedStart =
                  outputFormat.format(inputFormat.parse(weekTimeStart));
              final formattedEnd =
                  outputFormat.format(inputFormat.parse(weekTimeEnd));

              return DropdownMenuItem<String>(
                value: week,
                child: Row(
                  children: [
                    Text('Tuần $week'),
                    SizedBox(width: 8), // Khoảng cách giữa tuần và ngày bắt đầu
                    Text(
                        '(Từ $formattedStart - Đến $formattedEnd)'), // Hiển thị ngày bắt đầu và ngày kết thúc
                  ],
                ),
              );
            } else {
              return null;
            }
          })
          // .where((item) => item != null)
          // .toList()
          // .cast<DropdownMenuItem<String>>(),
          .whereType<DropdownMenuItem<String>>()
          .toList(),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    final appState = context.watch<AppStateProvider>().appState!;
    final filteredSchedules = appState.scheduleStudentWeeks.where((schedule) {
      return schedule['week'] == selectedWeek;
    }).toList();

    filteredSchedules.sort((a, b) {
      return scheduleDayComparator(a['day'], b['day']);
    });

    return DataTable(
      columns: [
        DataColumn(
            label: Expanded(child: Text('Thứ', textAlign: TextAlign.center))),
        DataColumn(
            label: Expanded(child: Text('Tiết', textAlign: TextAlign.center))),
        DataColumn(
            label: Expanded(
                child: Text('Mã học phần', textAlign: TextAlign.center))),
        DataColumn(
            label:
                Expanded(child: Text('Tên môn', textAlign: TextAlign.center))),
        DataColumn(
            label: Expanded(
                child: Text('Phòng học', textAlign: TextAlign.center))),
        DataColumn(
            label: Expanded(
                child: Text('Tên giảng viên', textAlign: TextAlign.center))),
        DataColumn(
            label: Expanded(
                child: Text('Điểm danh', textAlign: TextAlign.center))),
      ],
      rows: filteredSchedules.map((schedule) {
        return DataRow(
          cells: [
            DataCell(Center(child: Text(schedule['day']))),
            DataCell(Center(child: Text(schedule['time']))),
            DataCell(Center(child: Text(schedule['moduleID']))),
            DataCell(Center(child: Text(schedule['subjectName']))),
            DataCell(Center(child: Text(schedule['roomName']))),
            DataCell(Center(child: Text(schedule['lecturerName']))),
            // DataCell(Center(
            //     child: Utilities.attendanceImages(schedule['NoImages']))),
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isLoading
                      ? Container(
                          child: CircularProgressIndicator(),
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                        )
                      : IconButton(
                          icon: Icon(Icons.library_books),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(schedule['subjectName']),
                                  content: 
                                  Container(),
                                  // DetailAttendanceStudentDayWidget(
                                  //   dayID: schedule['dayID'],
                                  // ),
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
      }).toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildWeekDropdown(context),
          _isLoading
              ? Container(
                  child: CircularProgressIndicator(),
                  margin: EdgeInsets.only(bottom: 5, top: 10),
                )
              : Container(
                  width: MediaQuery.of(context).size.width - sideBarWidth,
                  child: _buildDataTable(context),
                ),
        ],
      ),
    );
  }
}
