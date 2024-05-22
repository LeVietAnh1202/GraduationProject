import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_lecturer_term.dart';
import 'package:flutter_todo_app/attendance/dtModule_by_lecturerID_term.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/lecturers/lecturerService.dart';
import 'package:flutter_todo_app/model/lecturerModel.dart';
import 'package:flutter_todo_app/model/schoolyearModel.dart';
import 'package:flutter_todo_app/model/semesterModel.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/scheduleService.dart';
import 'package:flutter_todo_app/schoolyears/schoolyearService.dart';
import 'package:flutter_todo_app/subjects/subjectService.dart';
import 'package:provider/provider.dart';

class AttendanceSelectionTerm extends StatefulWidget {
  // final String moduleID;
  // const AttendanceSelectionTerm({Key? key, required this.moduleID});
  @override
  _AttendanceSelectionTermState createState() =>
      _AttendanceSelectionTermState();
}

class _AttendanceSelectionTermState extends State<AttendanceSelectionTerm> {
  List<Schoolyear> schoolYears = [];
  List<Semester> semesters = [];
  List<Lecturer> lecturers = [];
  // List<Subject> subjects = [];
  int scheduleAdminTermsLength = 0;
  String moduleID = "";

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
  }

  // ignore: unused_field
  bool _isLoading = false;
  Future<void> fetchAttendanceTerms() async {
    try {
      if (!isNull()) {
        final scheduleAdminTerms =
            await ScheduleService.fetchAllModuleTermByLecturerIDs(
          context,
          (bool value) {
            setState(() {
              _isLoading = value;
            });
          },
          selectedLecturer!,
          // selectedSubject!,
          selectedSemester!,
        );
        Provider.of<AppStateProvider>(context, listen: false)
            .setTableLength(scheduleAdminTerms.length);
      }
    } catch (error) {
      print('Error fetchAllModuleTermByLecturerIDs: $error');
    }
  }

  bool isNull() {
    return
        // selectedSubject == null ||
        selectedSchoolYear == null ||
            selectedLecturer == null ||
            selectedSemester == null;
  }

  String? selectedSchoolYear;
  String? selectedSemester;
  String? selectedLecturer;
  // String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AccountProvider>().getRole();
    if (role == Role.lecturer)
      selectedLecturer =
          Provider.of<AccountProvider>(context, listen: false).account!.account;
    else
      lecturers = context.watch<AppStateProvider>().appState!.lecturers;

    schoolYears = context.watch<AppStateProvider>().appState!.schoolyears;
    // subjects = context.watch<AppStateProvider>().appState!.subjects;
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
                  onChanged: (String? newValue) async {
                    setState(() {
                      moduleID = "";
                      selectedSchoolYear = newValue;
                      semesters = schoolYears
                          .firstWhere((element) =>
                              element.schoolYearID == selectedSchoolYear)
                          .semesters;
                      selectedSemester = null; // Reset subsequent dropdowns
                    });
                    await fetchAttendanceTerms();
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
                  onChanged: (String? newValue) async {
                    setState(() {
                      moduleID = "";
                      selectedSemester = newValue;
                    });
                    await fetchAttendanceTerms();
                  },
                  items: (selectedSchoolYear != null)
                      ? semesters.asMap().entries.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.value.semesterID,
                            child: Text(e.value.semesterName),
                          );
                        }).toList()
                      : null,
                ),
              ],
            ),
            SizedBox(width: 10),

            // Dropdown for Lecturer
            if (role == Role.admin || role == Role.aao)
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
                      onChanged: (String? newValue) async {
                        setState(() {
                          moduleID = "";
                          selectedLecturer = newValue;
                        });
                        await fetchAttendanceTerms();
                      },
                      items:
                          // (selectedSemester != null) ?
                          lecturers.asMap().entries.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.value.lecturerID,
                          child: Text(e.value.lecturerName),
                        );
                      }).toList()
                      // : null,
                      ),
                ],
              ),
            SizedBox(width: 10),

            // Dropdown for Subject
            // Row(
            //   children: [
            //     Text(
            //       "Môn học:",
            //       style: TextStyle(fontSize: 16),
            //     ),
            //     SizedBox(width: 10),
            //     DropdownButton<String>(
            //         hint: Text(
            //           'Chọn môn học',
            //           style: TextStyle(fontSize: 16),
            //         ),
            //         value: selectedSubject,
            //         onChanged: (String? newValue) async {
            //           setState(() {
            //             moduleID = "";
            //             selectedSubject = newValue;
            //           });
            //           await fetchAttendanceTerms();
            //         },
            //         //
            //         items:
            //             // (selectedLecturer != null)  ?
            //             subjects.asMap().entries.map((e) {
            //           return DropdownMenuItem<String>(
            //             value: e.value.subjectID,
            //             child: Text(e.value.subjectName),
            //           );
            //         }).toList()
            //         // : null,
            //         ),
            //   ],
            // ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            if (!isNull())
              Expanded(
                  child: DtModuleByLecturerIDTerm(
                      lecturerID: selectedLecturer!,
                      // subjectID: selectedSubject!,
                      semesterID: selectedSemester!,
                      onPress: (moduleID_value, length) {
                        setState(() {
                          moduleID = moduleID_value;
                          scheduleAdminTermsLength = length;
                        });
                        print("moduleID: " + moduleID);
                      })),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (moduleID != '')
              AttendanceLecturerTerm(
                  moduleID: moduleID,
                  scheduleAdminTermsLength: scheduleAdminTermsLength)
          ],
        )
      ],
    );
  }
}
