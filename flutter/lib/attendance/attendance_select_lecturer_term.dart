import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendanceService.dart';
import 'package:flutter_todo_app/attendance/attendance_lecturer_term.dart';
import 'package:flutter_todo_app/lecturers/lecturerService.dart';
import 'package:flutter_todo_app/model/lecturerModel.dart';
import 'package:flutter_todo_app/model/schoolyearModel.dart';
import 'package:flutter_todo_app/model/semesterModel.dart';
import 'package:flutter_todo_app/model/subjectModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schoolyears/schoolyearService.dart';
import 'package:flutter_todo_app/subjects/subjectService.dart';
import 'package:provider/provider.dart';

class ScheduleSelection extends StatefulWidget {
  // final String moduleID;
  // const ScheduleSelection({Key? key, required this.moduleID});
  @override
  _ScheduleSelectionState createState() => _ScheduleSelectionState();
}

class _ScheduleSelectionState extends State<ScheduleSelection> {
  List<Schoolyear> schoolYears = [];
  List<Semester> semesters = [];
  List<Lecturer> lecturers = [];
  List<Subject> subjects = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      init(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
  }

  Future<void> init() async {
    await SchoolyearService.fetchSchoolyears(context, (value) => {});
    await LecturerService.fetchLecturers(context);
    await SubjectService.fetchSubjects(context);
    // await AttendanceService.fetchAttendanceLecturerTerms(
    //     context,
    //     (bool value) => setState(() {
    //           _isLoading = value;
    //         }),
    //     widget.moduleID);
  }

  String? selectedSchoolYear;
  String? selectedSemester;
  String? selectedLecturer;
  String? selectedSubject;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    schoolYears = context.watch<AppStateProvider>().appState!.schoolyears;
    lecturers = context.watch<AppStateProvider>().appState!.lecturers;
    subjects = context.watch<AppStateProvider>().appState!.subjects;
    print(subjects);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  "Năm học:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  hint: Text('Chọn năm học', style: TextStyle(fontSize: 16)),
                  value: selectedSchoolYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSchoolYear = newValue;
                      semesters = schoolYears
                          .firstWhere((element) =>
                              element.schoolYearID == selectedSchoolYear)
                          .semesters;
                      selectedSemester = null; // Reset subsequent dropdowns
                      selectedLecturer = null;
                      selectedSubject = null;
                    });
                  },
                  items: schoolYears.asMap().entries.map((entry) {
                    final schoolYear = entry.value;
                    return DropdownMenuItem<String>(
                      value: schoolYear.schoolYearID,
                      child: Text(schoolYear.schoolYearName),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(width: 10),

            // // Dropdown for Semester
            Row(
              children: [
                Text(
                  "Học kỳ:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  hint: Text('Chọn học kỳ', style: TextStyle(fontSize: 16)),
                  value: selectedSemester,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSemester = newValue;
                      selectedLecturer = null; // Reset subsequent dropdowns
                      selectedSubject = null;
                      print(selectedSemester);
                    });
                  },
                  items: (selectedSchoolYear != null)
                      ? semesters.asMap().entries.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.value.semesterID,
                            child: Text(e.value.semesterName),
                          );
                        }).toList()
                      : [
                          DropdownMenuItem<String>(
                            value: '123',
                            child: Text("124"),
                          ),
                          DropdownMenuItem<String>(
                            value: '123',
                            child: Text("124"),
                          )
                        ],
                ),
              ],
            ),
            SizedBox(width: 10),

            // Dropdown for Lecturer
            Row(
              children: [
                Text(
                  "Giảng viên:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  hint: Text(
                    'Chọn giảng viên',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: selectedLecturer,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLecturer = newValue;
                      selectedSubject = null; // Reset subsequent dropdowns
                    });
                  },
                  items: (selectedSemester != null)
                      ? lecturers.asMap().entries.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.value.lecturerID,
                            child: Text(e.value.lecturerName),
                          );
                        }).toList()
                      : null,
                ),
              ],
            ),
            SizedBox(width: 10),

            // Dropdown for Subject
            Row(
              children: [
                Text(
                  "Môn học:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  hint: Text(
                    'Chọn môn học',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: selectedSubject,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubject = newValue;
                    });
                  },
                  //
                  items: (selectedLecturer != null)
                      ? subjects.asMap().entries.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.value.subjectID,
                            child: Text(e.value.subjectName),
                          );
                        }).toList()
                      : null,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            if (selectedSubject != null)
              _isLoading
                  ? Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    )
                  :
                  // AttendanceLecturerTerm(
                  //     moduleID: 'moduleID',
                  //   ),
                  Expanded(
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Header 1')),
                          DataColumn(label: Text('Header 2')),
                          DataColumn(label: Text('Header 3')),
                        ],
                        rows: const <DataRow>[
                          DataRow(cells: <DataCell>[
                            DataCell(Text('Row 1, Cell 1')),
                            DataCell(Text('Row 1, Cell 2')),
                            DataCell(Text('Row 1, Cell 3')),
                          ]),
                          DataRow(cells: <DataCell>[
                            DataCell(Text('Row 2, Cell 1')),
                            DataCell(Text('Row 2, Cell 2')),
                            DataCell(Text('Row 2, Cell 3')),
                          ]),
                        ],
                      ),
                    ),
          ],
        )
      ],
    );
  }
}
