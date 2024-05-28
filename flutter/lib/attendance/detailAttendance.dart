import 'dart:collection';
import 'package:flutter_todo_app/constant/string.dart';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class _JsonMap extends MapView<dynamic, dynamic> {
  _JsonMap.fromJson(Map<dynamic, dynamic> json) : super(json);
}

class DetailAttendance extends StatefulWidget {
  final String dayID;
  const DetailAttendance({Key? key, required this.dayID});

  @override
  State<DetailAttendance> createState() => _DetailAttendanceState();
}

class _DetailAttendanceState extends State<DetailAttendance> {
  Map<String, dynamic> attendances = {};
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    attendances = Provider.of<AppStateProvider>(context, listen: false)
        // attendances = context.watch<AppStateProvider>()
        .appState!
        .attendanceLecturerWeeks;
    // if (attendances.isEmpty) {
    AttendanceService.fetchAttendanceLecturerWeeks(
        context,
        (bool value) => setState(() {
              _isLoading = value;
            }),
        widget.dayID);
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   }
    //   );
    // }
  }

  void deleteSchedule(int index) {
    // Xử lý logic xóa sinh viên ở hàng tương ứng
    // Ví dụ: students.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    int index = 0; // Biến đếm số thứ tự
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
                  dataRowHeight: 120,
                  dividerThickness: 2.0, // Độ dày của đường kẻ
                  // decoration: BoxDecoration(
                  //   border:
                  //       Border.all(color: Colors.grey), // Màu sắc của đường kẻ
                  // ),
                  border: TableBorder.all(color: Colors.grey),
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
                          'Mã sinh viên',
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
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Giới tính',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Lớp',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    for (var i = 0; i < 5; i++)
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Điểm danh ${i + 1}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Điểm danh',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: ((context
                          .watch<AppStateProvider>()
                          .appState!
                          .attendanceLecturerWeeks['studentAttendance']))
                      .map((entry) {
                        return DataRow(
                          cells: [
                            DataCell(Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (++index).toString(),
                                textAlign: TextAlign.right,
                              ),
                            )), // Thêm cột số thứ tự
                            DataCell(Center(child: Text(entry['studentId']))),
                            DataCell(Text(entry['studentName'])),
                            DataCell(Center(child: Text(entry['gender']))),
                            DataCell(Center(child: Text(entry['classCode']))),
                            // DataCell(Container(
                            //   height: 200,
                            //   width: 630,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis
                            //         .horizontal, // Hiển thị ảnh theo chiều ngang
                            //     itemCount: entry['attendanceImages']
                            //         .length, // Số lượng ảnh
                            //     itemBuilder: (context, index) {
                            //       // Tạo widget Image cho mỗi URL
                            //       return Padding(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal:
                            //                 10), // Khoảng cách giữa các ảnh

                            //         child: Column(
                            //           children: [
                            //             Image.network(
                            //               '${URLNodeJSServer}/images/attendance_images/${entry['attendanceImages'][index]}', // URL của ảnh
                            //               width: 100, // Chiều rộng của ảnh
                            //               height: 100, // Chiều cao của ảnh
                            //             ),
                            //             Text(
                            //               Utilities.formatImageTime(
                            //                   entry['attendanceImages'][index]),
                            //               style: TextStyle(fontSize: 13),
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // )),

                            ...List.generate(5, (i) {
                              return DataCell(
                                Container(
                                  height: 150,
                                  width: 120,
                                  child: entry['attendanceImages'].length > i
                                      ? Column(
                                          children: [
                                            Image.network(
                                              '${URLNodeJSServer}/images/attendance_images/${entry['attendanceImages'][i]}',
                                              width: 100,
                                              height: 100,
                                            ),
                                            Text(
                                              Utilities.formatImageTime(
                                                  entry['attendanceImages'][i]),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              );
                            }),
                            DataCell(Center(
                              child: Utilities.attendanceIcon(
                                  entry['attendanceValue']),
                            )),
                          ],
                        );
                      })
                      .whereType<DataRow>()
                      .toList(growable: false)

                  // ..sort((a, b) => (
                  //     ((a.cells[0].child as Center).child as Text)
                  //         .data
                  //         .toString(),
                  //     ((b.cells[0].child as Center).child as Text)
                  //         .data
                  //         .toString()
                  //         )
                  ),
            ),
          );
  }
}
