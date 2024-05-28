// import 'package:flutter/material.dart';
// import 'package:flutter_todo_app/lecturers/lecturerService.dart';
// import 'package:flutter_todo_app/model/lecturerModel.dart';
// import 'package:flutter_todo_app/model/schoolyearModel.dart';
// import 'package:flutter_todo_app/model/semesterModel.dart';
// import 'package:flutter_todo_app/model/subjectModel.dart';
// import 'package:flutter_todo_app/provider/appState.dart';
// import 'package:flutter_todo_app/schedules/dtSchedule_Term.dart';
// import 'package:flutter_todo_app/schedules/scheduleService.dart';
// import 'package:flutter_todo_app/schoolyears/schoolyearService.dart';
// import 'package:flutter_todo_app/subjects/subjectService.dart';
// import 'package:provider/provider.dart';

// class ScheduleAdminWidget extends StatefulWidget {
//   @override
//   _ScheduleAdminWidgetState createState() => _ScheduleAdminWidgetState();
// }

// class _ScheduleAdminWidgetState extends State<ScheduleAdminWidget> {
//   List<Schoolyear> schoolYears = [];
//   List<Semester> semesters = [];
//   List<Lecturer> lecturers = [];
//   List<Subject> subjects = [];

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       init(); // Gọi hàm setAppState sau khi initState hoàn thành
//     });
//   }

//   Future<void> init() async {
//     await SchoolyearService.fetchSchoolyears(context, (value) => {});
//     await LecturerService.fetchLecturers(context);
//     await SubjectService.fetchSubjects(context);
//   }

//   String? selectedSchoolYear;
//   String? selectedSemester;
//   String? selectedLecturer;
//   String? selectedSubject;

//   bool _isLoading = true;

//   Future<void> fetchScheduleAdminTerms() async {
//     try {
//       if (!isNull()) {
//         final scheduleAdminTerms =
//             await ScheduleService.fetchAllModuleTermByLecturerIDs(
//           context,
//           (bool value) {
//             setState(() {
//               _isLoading = value;
//             });
//           },
//           selectedLecturer!,
//           // selectedSubject!,
//           selectedSemester!,
//         );
//         Provider.of<AppStateProvider>(context, listen: false)
//             .setTableLength(scheduleAdminTerms.length);
//       }
//     } catch (error) {
//       print('Error fetching schedule admin terms: $error');
//     }
//   }

//   bool isNull() {
//     return selectedSubject == null ||
//         selectedSchoolYear == null ||
//         selectedLecturer == null ||
//         selectedSemester == null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     schoolYears = context.watch<AppStateProvider>().appState!.schoolyears;
//     lecturers = context.watch<AppStateProvider>().appState!.lecturers;
//     subjects = context.watch<AppStateProvider>().appState!.subjects;
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   "Năm học:",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(width: 10),
//                 DropdownButton<String>(
//                   hint: Text('Chọn năm học', style: TextStyle(fontSize: 16)),
//                   value: selectedSchoolYear,
//                   onChanged: (String? newValue) async {
//                     setState(() {
//                       selectedSchoolYear = newValue;
//                       semesters = schoolYears
//                           .firstWhere((element) =>
//                               element.schoolYearID == selectedSchoolYear)
//                           .semesters;
//                       selectedSemester = null; // Reset subsequent dropdowns
//                       // selectedLecturer = null;
//                       // selectedSubject = null;
//                     });
//                     await fetchScheduleAdminTerms();
//                   },
//                   items: schoolYears.asMap().entries.map((entry) {
//                     final schoolYear = entry.value;
//                     return DropdownMenuItem<String>(
//                       value: schoolYear.schoolYearID,
//                       child: Text(schoolYear.schoolYearName),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//             SizedBox(width: 10),

//             // // Dropdown for Semester
//             Row(
//               children: [
//                 Text(
//                   "Học kỳ:",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(width: 10),
//                 DropdownButton<String>(
//                   hint: Text('Chọn học kỳ', style: TextStyle(fontSize: 16)),
//                   value: selectedSemester,
//                   onChanged: (String? newValue) async {
//                     setState(() {
//                       selectedSemester = newValue;
//                       // selectedLecturer = null; // Reset subsequent dropdowns
//                       // selectedSubject = null;
//                     });
//                     await fetchScheduleAdminTerms();
//                   },
//                   items: (selectedSchoolYear != null)
//                       ? semesters.asMap().entries.map((e) {
//                           return DropdownMenuItem<String>(
//                             value: e.value.semesterID,
//                             child: Text(e.value.semesterName),
//                           );
//                         }).toList()
//                       : null,
//                 ),
//               ],
//             ),
//             SizedBox(width: 10),

//             // Dropdown for Lecturer
//             Row(
//               children: [
//                 Text(
//                   "Giảng viên:",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(width: 10),
//                 DropdownButton<String>(
//                     hint: Text(
//                       'Chọn giảng viên',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     value: selectedLecturer,
//                     onChanged: (String? newValue) async {
//                       setState(() {
//                         selectedLecturer = newValue;
//                         // selectedSubject = null; // Reset subsequent dropdowns
//                       });
//                       await fetchScheduleAdminTerms();
//                     },
//                     items:
//                         // (selectedSemester != null) ?
//                         lecturers.asMap().entries.map((e) {
//                       return DropdownMenuItem<String>(
//                         value: e.value.lecturerID,
//                         child: Text(e.value.lecturerName),
//                       );
//                     }).toList()
//                     // : null,
//                     ),
//               ],
//             ),
//             SizedBox(width: 10),

//             // Dropdown for Subject
//             Row(
//               children: [
//                 Text(
//                   "Môn học:",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(width: 10),
//                 DropdownButton<String>(
//                     hint: Text(
//                       'Chọn môn học',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     value: selectedSubject,
//                     onChanged: (String? newValue) async {
//                       setState(() {
//                         selectedSubject = newValue;
//                       });
//                       await fetchScheduleAdminTerms();
//                     },
//                     //
//                     items:
//                         // (selectedLecturer != null) ?
//                         subjects.asMap().entries.map((e) {
//                       return DropdownMenuItem<String>(
//                         value: e.value.subjectID,
//                         child: Text(e.value.subjectName),
//                       );
//                     }).toList()
//                     // : null,
//                     ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 20),
//         Row(
//           children: [
//             if (!isNull())
//               // _isLoading
//               //     ? Container(
//               //         alignment: Alignment.center,
//               //         width: 60,
//               //         height: 60,
//               //         child: CircularProgressIndicator(),
//               //       )
//               //     :
//               Expanded(
//                   child: DtScheduleTerm(
//                       lecturerID: selectedLecturer!,
//                       // subjectID: selectedSubject!,
//                       semesterID: selectedSemester!)),
//           ],
//         )
//       ],
//     );
//   }
// }
