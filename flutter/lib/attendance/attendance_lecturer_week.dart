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

class AttendanceLecturerWeek extends StatefulWidget {
  final String dayID;
  const AttendanceLecturerWeek({Key? key, required this.dayID});

  @override
  State<AttendanceLecturerWeek> createState() => _AttendanceLecturerWeekState();
}

class _AttendanceLecturerWeekState extends State<AttendanceLecturerWeek> {
  Map<String, dynamic> attendances = {};
  // List<String> dateList = ["21/12/2023", "22/12/2023", "23/12/2023"];
  bool _isLoading = true;
  // String selectedWeek = '19'; // Tuần được chọn mặc định

  // void onWeekSelected(String? week) {
  //   setState(() {
  //     selectedWeek = week!;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    print('widget.dayID: ' + widget.dayID);
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
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'FaceID',
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
                        print('entry attendance lecturer week datacell');
                        // print(entry);
                        // final index = entry.keys.first;
                        print('entry');
                        print(entry);
                        // final studentAttendance = entry.value['studentAttendance'];
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
                            DataCell(Container(
                              height: 200,
                              width: 630,
                              child: ListView.builder(
                                scrollDirection: Axis
                                    .horizontal, // Hiển thị ảnh theo chiều ngang
                                itemCount: entry['attendanceImages']
                                    .length, // Số lượng ảnh
                                itemBuilder: (context, index) {
                                  // Tạo widget Image cho mỗi URL
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            10), // Khoảng cách giữa các ảnh

                                    child: Column(
                                      children: [
                                        Image.network(
                                          '${URLNodeJSServer}/images/attendance_images/${entry['attendanceImages'][index]}', // URL của ảnh
                                          width: 100, // Chiều rộng của ảnh
                                          height: 100, // Chiều cao của ảnh
                                        ),
                                        Text(
                                          Utilities.formatImageTime(
                                              entry['attendanceImages'][index]),
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                                //   SizedBox(
                                //   height: 50,
                                //   width: 50,
                                //   child: GridView.builder(
                                //     shrinkWrap: true,
                                //     gridDelegate:
                                //         SliverGridDelegateWithFixedCrossAxisCount(
                                //       crossAxisCount: 10,
                                //       crossAxisSpacing: 8.0,
                                //       mainAxisSpacing: 8.0,
                                //     ),
                                //     itemCount: 1,
                                //     itemBuilder: (context, index) {
                                //       return Container(
                                //         padding: EdgeInsets.all(8.0),
                                //         child: Column(children: [
                                //           Image.network(
                                //             '${URLNodeJSServer}/images/attendance_images/${entry.attendanceImages[0]}',
                                //             width:
                                //                 131, // Điều chỉnh chiều rộng nếu cần
                                //             height:
                                //                 131, // Điều chỉnh chiều cao nếu cần
                                //             fit: BoxFit.contain,
                                //             loadingBuilder: (BuildContext context,
                                //                 Widget child,
                                //                 ImageChunkEvent? loadingProgress) {
                                //               if (loadingProgress == null) {
                                //                 return child;
                                //               } else {
                                //                 return CircularProgressIndicator();
                                //               }
                                //             },
                                //             errorBuilder: (BuildContext context,
                                //                 Object error,
                                //                 StackTrace? stackTrace) {
                                //               return Image.network(
                                //                 '${URLNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                                //                 width:
                                //                     131, // Điều chỉnh chiều rộng nếu cần
                                //                 height:
                                //                     131, // Điều chỉnh chiều cao nếu cần
                                //               );
                                //             },
                                //           ),
                                //           SizedBox(height: 10),
                                //           Text(
                                //             'Image ' + (index + 1).toString(),
                                //             style: TextStyle(
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.bold),
                                //           )
                                //         ]),
                                //       );
                                //     },
                                //   ),
                                // )
                                ),
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
