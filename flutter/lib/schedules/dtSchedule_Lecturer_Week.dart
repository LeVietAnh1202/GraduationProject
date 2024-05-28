import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/detailAttendance.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/export/exxport_attendance_lecturer_week.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DtScheduleLecturerWeek extends StatefulWidget {
  const DtScheduleLecturerWeek({Key? key});

  @override
  State<DtScheduleLecturerWeek> createState() => _DtScheduleLecturerWeekState();
}

class _DtScheduleLecturerWeekState extends State<DtScheduleLecturerWeek> {
  List<Map<String, dynamic>> schedules = [];
  bool _isLoading = true;
  String selectedWeek = '19'; // Tuần được chọn mặc định

  void onWeekSelected(String? week) {
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
    schedules = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .scheduleLecturerWeeks;
    if (schedules.isEmpty) {
      ScheduleService.fetchScheduleLecturerWeeks(
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

  Widget buildWeekDropdown(BuildContext context) {
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
        context.watch<AppStateProvider>().appState!.scheduleLecturerWeeks;

    return !schedules.isEmpty
        ? DropdownButton<String>(
            value: selectedWeek,
            onChanged: onWeekSelected,
            items: weeks
                .map((week) {
                  final schedule = schedules.firstWhere(
                    (schedule) => schedule['week'] == week,
                    orElse: () => {'weekTimeStart': '', 'weekTimeEnd': ''},
                  );
                  final weekTimeStart = schedule['weekTimeStart'];
                  final weekTimeEnd = schedule['weekTimeEnd'];

                  String formattedStart = '';
                  String formattedEnd = '';

                  if (weekTimeStart != '' && weekTimeEnd != '') {
                    final inputFormat =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                    final outputFormat = DateFormat('dd/MM/yyyy');

                    formattedStart =
                        outputFormat.format(inputFormat.parse(weekTimeStart));
                    formattedEnd =
                        outputFormat.format(inputFormat.parse(weekTimeEnd));

                    return DropdownMenuItem<String>(
                      value: week,
                      child: Row(
                        children: [
                          Text('Tuần $week'),
                          SizedBox(
                              width:
                                  8), // Khoảng cách giữa tuần và ngày bắt đầu
                          Text(
                              '(Từ $formattedStart - Đến $formattedEnd)'), // Hiển thị ngày bắt đầu và ngày kết thúc
                        ],
                      ),
                    );
                  } else {
                    return null;
                  }
                })
                .where((item) => item != null)
                .toList()
                .cast<DropdownMenuItem<String>>(),
          )
        : DropdownButton<String>(value: '', onChanged: (value) {}, items: []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          buildWeekDropdown(context),
          _isLoading
              ? Container(
                  child: CircularProgressIndicator(),
                  margin: EdgeInsets.only(bottom: 5, top: 10),
                )
              : Container(
                  width: MediaQuery.of(context).size.width - sideBarWidth,
                  child: DataTable(
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
                              'Phòng học',
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
                          .scheduleLecturerWeeks
                          .asMap()
                          .entries
                          .map((entry) {
                            final schedule = entry.value;

                            if (schedule['week'] == selectedWeek) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                      Center(child: Text(schedule['day']))),
                                  DataCell(
                                      Center(child: Text(schedule['time']))),
                                  DataCell(Center(
                                      child: Text(schedule['moduleID']))),
                                  DataCell(Center(
                                      child: Text(schedule['subjectName']))),
                                  DataCell(Center(
                                      child: Text(schedule['roomName']))),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.library_books),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      schedule['subjectName']),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 20),
                                                            Text("Tiết: " +
                                                                schedule[
                                                                    'time']),
                                                            SizedBox(width: 20),
                                                            Text("Phòng: " +
                                                                schedule[
                                                                    'roomName']),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20),
                                                        // AttendanceLecturerWeek(
                                                        //   dayID:
                                                        //       schedule['dayID'],
                                                        // ),
                                                        DetailAttendance(
                                                            dayID: schedule[
                                                                'dayID'])
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Hủy'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    Utilities.exportFileButton(
                                                        () {
                                                      ExportExcel
                                                          .exportAttendanceLecturerWeekToExcel(
                                                        Provider.of<AppStateProvider>(
                                                                context,
                                                                listen: false)
                                                            .appState!
                                                            .attendanceLecturerWeeks,
                                                        schedule['subjectName'],
                                                        schedule['classCode'],
                                                        schedule['week'],
                                                        schedule['day'],
                                                        schedule['time'],
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
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
                            } else {
                              return null; // Không trả về gì nếu không phải tuần 19
                            }
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
                ),
        ],
      ),
    );
  }
}
