import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DtScheduleStudentWeek extends StatefulWidget {
  // final ValueChanged<bool> haveContentFunc;
  DtScheduleStudentWeek({
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
        .scheduleStudentWeeks;
    if (schedules.isEmpty) {
      ScheduleService.fetchScheduleStudentWeeks(
          context,
          (bool value) => setState(() {
                _isLoading = value;
              }));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? scheduleStudentWeeksString =
    //     prefs.getString('scheduleStudentWeeks');

    // if (scheduleStudentWeeksString == null ) {
    //   ScheduleService.fetchScheduleStudentWeeks(
    //       context,
    //       (bool value) => setState(() {
    //             _isLoading = value;
    //           }));
    // } else {
    //   Provider.of<AppStateProvider>(context, listen: false).restoreFromSharedPreferences();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
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
        context.watch<AppStateProvider>().appState!.scheduleStudentWeeks;

    // return DropdownButton<String>(
    //   value: selectedWeek,
    //   onChanged: onWeekSelected,
    //   items: weeks.map((week) {
    //     return DropdownMenuItem<String>(
    //       value: week,
    //       child: Text('Tuần $week'),
    //     );
    //   }).toList(),
    // );

    return DropdownButton<String>(
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

            print('weekTimeStart: $weekTimeStart');
            print('weekTimeEnd: $weekTimeEnd');

            if (weekTimeStart != '' && weekTimeEnd != '') {
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
          .where((item) => item != null)
          .toList()
          .cast<DropdownMenuItem<String>>(),
    );
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
                              'Tên giảng viên',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Điểm danh',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Add other columns as needed
                      ],
                      rows: context
                          .watch<AppStateProvider>()
                          .appState!
                          .scheduleStudentWeeks
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
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
                                  DataCell(Center(
                                      child: Text(schedule['lecturerName']))),
                                  DataCell(
                                    Center(
                                        child: Utilities.attendanceIcon(
                                            schedule['attendance'])),
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
