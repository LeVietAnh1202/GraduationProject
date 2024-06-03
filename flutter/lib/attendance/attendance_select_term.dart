import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_lecturer_term.dart';
import 'package:flutter_todo_app/attendance/attendance_student_term.dart';
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
  int scheduleAdminTermsLength = 0;
  String moduleID = "";
  String? selectedSchoolYear;
  String? selectedSemester;
  String? selectedLecturer;
  String? selectedStudent;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      init(); // Gọi hàm init sau khi initState hoàn thành
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    try {
      // Fetch school years
      final schoolyears = await SchoolyearService.fetchSchoolyears((value) {});
      final appStateProvider =
          Provider.of<AppStateProvider>(context, listen: false);
      appStateProvider.setSchoolyears(schoolyears);

      // Fetch lecturers
      final accountProvider =
          Provider.of<AccountProvider>(context, listen: false);
      final role = accountProvider.getRole();
      final lecturerID = accountProvider.getAccount();
      final lecturers = await LecturerService.fetchLecturers(role, lecturerID);

      appStateProvider.setLecturers(lecturers);
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  Future<void> fetchAttendanceTerms() async {
    if (!isNull()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final scheduleAdminTerms =
            await ScheduleService.fetchAllModuleTermByLecturerIDs(
          context,
          (bool value) {
            setState(() {
              _isLoading = value;
            });
          },
          selectedLecturer!,
          selectedSemester!,
          selectedStudent!,
        );
        Provider.of<AppStateProvider>(context, listen: false)
            .setTableLength(scheduleAdminTerms.length);
      } catch (error) {
        print('Error fetchAllModuleTermByLecturerIDs: $error');
      }
    }
  }

  bool isNull() {
    final role = Provider.of<AccountProvider>(context, listen: false).getRole();
    if (role == Role.student) {
      selectedLecturer = '';
      return selectedSchoolYear == null || selectedSemester == null;
    }
    selectedStudent = '';
    return selectedSchoolYear == null ||
        selectedLecturer == null ||
        selectedSemester == null;
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(width: 10),
        DropdownButton<String>(
          hint: Text(hint, style: TextStyle(fontSize: 16)),
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();
    final appStateProvider = context.watch<AppStateProvider>();

    final role = accountProvider.getRole();
    final account = accountProvider.account?.account;

    if (role == Role.lecturer) {
      selectedLecturer = account ?? '';
      selectedStudent = '';
    } else if (role == Role.student) {
      selectedStudent = account ?? '';
      selectedLecturer = '';
    } else {
      lecturers = appStateProvider.appState?.lecturers ?? [];
      selectedStudent = '';
    }

    schoolYears = appStateProvider.appState?.schoolyears ?? [];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDropdown(
              label: "Năm học:",
              value: selectedSchoolYear,
              hint: 'Chọn năm học',
              items: schoolYears
                  .map((sy) => DropdownMenuItem<String>(
                        value: sy.schoolYearID,
                        child: Text(sy.schoolYearName),
                      ))
                  .toList(),
              onChanged: (String? newValue) async {
                setState(() {
                  moduleID = "";
                  selectedSchoolYear = newValue;
                  semesters = schoolYears
                      .firstWhere((sy) => sy.schoolYearID == selectedSchoolYear)
                      .semesters;
                  selectedSemester = null;
                });
              },
            ),
            SizedBox(width: 10),
            // // Dropdown for Semester
            _buildDropdown(
              label: "Học kỳ:",
              value: selectedSemester,
              hint: 'Chọn học kỳ',
              items: (selectedSchoolYear != null)
                  ? semesters
                      .map((s) => DropdownMenuItem<String>(
                            value: s.semesterID,
                            child: Text(s.semesterName),
                          ))
                      .toList()
                  : [],
              onChanged: (String? newValue) async {
                setState(() {
                  moduleID = "";
                  selectedSemester = newValue;
                });
                if (role == Role.student) await fetchAttendanceTerms();
              },
            ),
            SizedBox(width: 10),

            // Dropdown for Lecturer
            if (role == Role.admin || role == Role.aao)
              _buildDropdown(
                label: "Giảng viên:",
                value: selectedLecturer,
                hint: 'Chọn giảng viên',
                items: lecturers
                    .map((l) => DropdownMenuItem<String>(
                          value: l.lecturerID,
                          child: Text(l.lecturerName),
                        ))
                    .toList(),
                onChanged: (String? newValue) async {
                  setState(() {
                    moduleID = "";
                    selectedLecturer = newValue;
                  });
                  await fetchAttendanceTerms();
                },
              ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            if (!isNull())
              _isLoading
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        width: 60,
                        height: 60,
                        child: Container(
                          child: CircularProgressIndicator(),
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                        ),
                      ),
                    )
                  : Expanded(
                      child: DtModuleByLecturerIDTerm(
                          lecturerID: selectedLecturer!,
                          semesterID: selectedSemester!,
                          studentId: selectedStudent!,
                          onPress: (moduleID_value, length) {
                            setState(() {
                              moduleID = moduleID_value;
                              scheduleAdminTermsLength = length;
                            });
                          })),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (moduleID.isNotEmpty && role == Role.student)
              Expanded(child: AttendanceStudentTerm(moduleID: moduleID)),
            if (moduleID.isNotEmpty &&
                (role == Role.admin ||
                    role == Role.aao ||
                    role == Role.lecturer))
              Expanded(
                  child: AttendanceLecturerTerm(
                      moduleID: moduleID,
                      scheduleAdminTermsLength: scheduleAdminTermsLength))
          ],
        )
      ],
    );
  }
}
