import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/moduleTermByLecturerIDModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DtModuleByLecturerIDTerm extends StatefulWidget {
  Function(String, int) onPress;
  String lecturerID;
  // String subjectID;
  String semesterID;
  DtModuleByLecturerIDTerm(
      {Key? key,
      required this.lecturerID,
      // required this.subjectID,
      required this.semesterID,
      required this.onPress});

  @override
  State<DtModuleByLecturerIDTerm> createState() => _DtModuleByLecturerIDTermState();
}

class _DtModuleByLecturerIDTermState extends State<DtModuleByLecturerIDTerm> {
  List<ModuleTermByLecturerID> scheduleAdminTerms = [];
  bool _isLoading = true;
  String moduleID = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchAttendanceTerms(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
    print(
        'initState DtModuleByLecturerIDTerm ${widget.lecturerID}, ${widget.semesterID}');
  }

  Future<void> fetchAttendanceTerms() async {
    scheduleAdminTerms = await ScheduleService.fetchAllModuleTermByLecturerIDs(
        context, (bool value) {
      setState(() {
        _isLoading = value;
      });
    }, widget.lecturerID, widget.semesterID);
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
    // fetchAttendanceTerms();
    print('DtModuleByLecturerIDTerm ${widget.lecturerID}, ${widget.semesterID}');
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
              dividerThickness: 2.0, // Độ dày của đường kẻ
              border: TableBorder.all(color: Colors.grey),
              columns: [
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
                  .moduleTermByLecturerIDs
                  .asMap()
                  .entries
                  .map((entry) {
                    final module = entry.value;
                    final dateStart = module.dateStart;
                    final dateEnd = module.dateEnd;

                    // final inputFormat =
                    //     DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                    final outputFormat = DateFormat('dd/MM/yyyy');

                    final formattedStart = outputFormat.format(dateStart);
                    final formattedEnd = outputFormat.format(dateEnd);

                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text(module.moduleID))),
                        DataCell(Center(child: Text(module.subjectName))),
                        DataCell(Center(
                            child: Text(module.numberOfCredits.toString()))),
                        DataCell(Center(child: Text(module.roomName))),
                        DataCell(Center(
                            child:
                                Text('${formattedStart} - ${formattedEnd}'))),
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
                                      onPressed: () async {
                                        scheduleAdminTerms =
                                            Provider.of<AppStateProvider>(
                                                    context,
                                                    listen: false)
                                                .appState!
                                                .moduleTermByLecturerIDs;
                                        print('scheduleAdminTerms.length: ' +
                                            scheduleAdminTerms.length
                                                .toString());
                                        widget.onPress(module.moduleID,
                                            scheduleAdminTerms.length);

                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) {
                                        //     return AlertDialog(
                                        //       title: Text(listStudent.subjectName),
                                        //       content: DataTableStudentByModule(
                                        //           moduleID: listStudent.moduleID),
                                        //       actions: [
                                        //         TextButton(
                                        //           child: Text('Hủy'),
                                        //           onPressed: () {
                                        //             Navigator.of(context).pop();
                                        //           },
                                        //         ),
                                        //       ],
                                        //     );
                                        //   },
                                        // );
                                      },
                                    )
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
