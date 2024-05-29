import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

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
      init();
    });
  }

  void init() async {
    // attendances = Provider.of<AppStateProvider>(context, listen: false)
    //     .appState!
    //     .attendanceStudentTerms;
    attendances = await AttendanceService.fetchAttendanceStudentTerms(
        context,
        (bool value) => setState(() {
              _isLoading = value;
            }),
        widget.moduleID);
  }

  // int vietnameseCollator = Collator('vi');

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    // attendances =
    //     context.watch<AppStateProvider>().appState!.attendanceStudentTerms;
    print('attendances');
    print(attendances);
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
        : SingleChildScrollView(
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
                          .attendanceStudentTerms['dateList'] as List<dynamic>)
                      .map<DataColumn>((entry) {
                    print('entry.keys.first');
                    print(entry.keys.first);
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
                      return DataCell(Center(
                        child: Utilities.attendanceImages(value['NoImages']),
                      ));
                    }).toList(),
                    DataCell(Center(
                        child: Text((attendances['NoImagesValid'] == 0
                                ? '-'
                                : attendances['NoImagesValid'])
                            .toString()))),
                  ])
                ],
              ),
            ));
  }
}
