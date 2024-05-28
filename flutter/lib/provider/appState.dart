import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/model/classModel.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:flutter_todo_app/model/lecturerModel.dart';
import 'package:flutter_todo_app/model/moduleTermByLecturerIDModel.dart';
import 'package:flutter_todo_app/model/scheduleAdminTermModel.dart';
import 'package:flutter_todo_app/model/schoolyearModel.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/model/subjectModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppState {
  // Map<String, dynamic>? _parsedSharedPreferencesData;

  String breadcrumbs;
  Calendar calendarView;
  ShowImage imagesView;
  int tableLength;
  int currentPage;
  int rowsPerPage;
  List<Student> students;
  List<Class> classes;
  List<Schoolyear> schoolyears;
  List<Faculty> faculties;
  List<Lecturer> lecturers;
  List<Subject> subjects;
  List<ScheduleAdminTerm> scheduleAdminTerms;
  List<ModuleTermByLecturerID> moduleTermByLecturerIDs;
  List<Map<String, dynamic>> scheduleStudentWeeks;
  List<Map<String, dynamic>> scheduleStudentTerms;
  List<Map<String, dynamic>> scheduleLecturerWeeks;
  List<Map<String, dynamic>> scheduleLecturerTerms;

  Map<String, dynamic> attendanceStudentTerms;
  Map<String, dynamic> attendanceLecturerWeeks;
  List<Map<String, dynamic>> attendanceLecturerTerms;
  List<Map<String, dynamic>> attendanceAdminWeeks;
  List<Map<String, dynamic>> attendanceAdminTerms;

  late IO.Socket socket;

  AppState({
    required this.breadcrumbs,
    required this.calendarView,
    required this.imagesView,
    required this.tableLength,
    required this.currentPage,
    required this.rowsPerPage,
    required this.students,
    required this.classes,
    required this.schoolyears,
    required this.faculties,
    required this.lecturers,
    required this.subjects,
    required this.scheduleStudentWeeks,
    required this.scheduleStudentTerms,
    required this.scheduleLecturerWeeks,
    required this.scheduleLecturerTerms,
    required this.scheduleAdminTerms,
    required this.moduleTermByLecturerIDs,
    required this.attendanceStudentTerms,
    required this.attendanceLecturerWeeks,
    required this.attendanceLecturerTerms,
    required this.attendanceAdminWeeks,
    required this.attendanceAdminTerms,
  }) {
    // socket = IO.io(URLNodeJSServer,
    //     IO.OptionBuilder().setTransports(['websocket']).build());
  }
}

class AppStateProvider with ChangeNotifier {
  AppState? _appState;

  AppState? get appState => _appState;

  AppStateProvider() {
    restoreFromSharedPreferences();
  }

  List<Map<String, dynamic>> parseJsonListOld(String jsonString) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    // List<Map<String, dynamic>> resultList = [];
    // for (var jsonObject in jsonList) {
    //   resultList.add(Map<String, dynamic>.from(jsonObject));
    // }
    // return resultList;
    return jsonList
        .map((jsonObject) => Map<String, dynamic>.from(jsonObject))
        .toList();
  }

  // List<T> parseJsonList<T>(
  //     String jsonString, T Function(Map<String, dynamic>) fromMap) {
  //   // List<dynamic> jsonList = jsonDecode(jsonString);
  //   List<Map<String, dynamic>> jsonList =
  //       List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  //   // List<T> resultList = [];
  //   // for (var jsonItem in jsonList) {
  //   //   resultList.add(fromMap(jsonItem));
  //   // }
  //   // return resultList;
  //   return jsonList.map((jsonObject) => fromMap(jsonObject)).toList();
  // }

  List<T> parseJsonList<T>(
      String jsonString, T Function(Map<String, dynamic>) fromMap) {
    // List<dynamic> jsonList = jsonDecode(jsonString);
    List<Map<String, dynamic>> jsonList =
        List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    // List<T> resultList = [];
    // for (var jsonItem in jsonList) {
    //   resultList.add(fromMap(jsonItem));
    // }
    // return resultList;
    return jsonList.map((jsonObject) => fromMap(jsonObject)).toList();
  }

  void setAppState(AppState appState) async {
    _appState = appState;
    await saveToSharedPreferences(appState);
    notifyListeners();
  }

  void setBreadcrumbs(String breadcrumbs) {
    _appState?.breadcrumbs = breadcrumbs;
    notifyListeners();
  }

  void setTableLength(int tableLength) {
    _appState?.tableLength = tableLength;
    notifyListeners();
  }

  void setCurrentPage(int currentPage) {
    _appState?.currentPage = currentPage;
    notifyListeners();
  }

  void goToPreviousPage() {
    _appState?.currentPage =
        _appState!.currentPage > 1 ? _appState!.currentPage - 1 : 1;
    notifyListeners();
  }

  void goToNextPage() {
    _appState?.currentPage = _appState!.currentPage <
            (_appState!.tableLength / _appState!.rowsPerPage).ceil()
        ? _appState!.currentPage + 1
        : (_appState!.tableLength / _appState!.rowsPerPage).ceil();
    notifyListeners();
  }

  void goToLastPage() {
    _appState?.currentPage =
        (_appState!.tableLength / _appState!.rowsPerPage).ceil();
    notifyListeners();
  }

  int getNumberOfPages() {
    return (_appState!.tableLength / _appState!.rowsPerPage).ceil();
  }

  void setRowsPerPage(int rowsPerPage) {
    _appState?.rowsPerPage = rowsPerPage;
    notifyListeners();
  }

  void setStudents(List<Student> students) {
    _appState?.students = students;
    notifyListeners();
  }

  void setClasses(List<Class> classes) {
    _appState?.classes = classes;
    notifyListeners();
  }

  void setSchoolyears(List<Schoolyear> schoolyears) {
    _appState?.schoolyears = schoolyears;
    notifyListeners();
  }

  void setFaculties(List<Faculty> faculties) {
    _appState?.faculties = faculties;
    notifyListeners();
  }

  // void setStudents(List<Map<String, dynamic>> students) {
  //   _appState?.students = students;
  //   notifyListeners();
  // }

  void setLecturers(List<Lecturer> lecturers) {
    _appState?.lecturers = lecturers;
    notifyListeners();
  }

  void setSubjects(List<Subject> subjects) {
    _appState?.subjects = subjects;
    notifyListeners();
  }
  // ----------------------------------------------------------------

  void setScheduleStudentWeeks(
      List<Map<String, dynamic>> scheduleStudentWeeks) {
    _appState?.scheduleStudentWeeks = scheduleStudentWeeks;
    notifyListeners();
  }

  void setScheduleStudentTerms(
      List<Map<String, dynamic>> scheduleStudentTerms) {
    _appState?.scheduleStudentTerms = scheduleStudentTerms;
    notifyListeners();
  }

  void setScheduleLecturerWeeks(
      List<Map<String, dynamic>> scheduleLecturerWeeks) {
    _appState?.scheduleLecturerWeeks = scheduleLecturerWeeks;
    notifyListeners();
  }

  void setScheduleLecturerTerms(
      List<Map<String, dynamic>> scheduleLecturerTerms) {
    _appState?.scheduleLecturerTerms = scheduleLecturerTerms;
    notifyListeners();
  }

  void setScheduleAdminTerms(List<ScheduleAdminTerm> scheduleAdminTerms) {
    _appState?.scheduleAdminTerms = scheduleAdminTerms;
    notifyListeners();
  }

  void setModuleTermByLecturerIDs(
      List<ModuleTermByLecturerID> moduleTermByLecturerIDs) {
    _appState?.moduleTermByLecturerIDs = moduleTermByLecturerIDs;
    notifyListeners();
  }

// ----------------------------------------------------------------
  void setAttendanceStudentTerms(Map<String, dynamic> attendanceStudentTerms) {
    _appState?.attendanceStudentTerms = attendanceStudentTerms;
    notifyListeners();
  }

  void setAttendanceLecturerWeeks(
      Map<String, dynamic> attendanceLecturerWeeks) {
    _appState?.attendanceLecturerWeeks = attendanceLecturerWeeks;
    notifyListeners();
  }

  void setAttendanceLecturerTerms(
      List<Map<String, dynamic>> attendanceLecturerTerms) {
    _appState?.attendanceLecturerTerms = attendanceLecturerTerms;
    notifyListeners();
  }

  void setAttendanceAdminWeeks(
      List<Map<String, dynamic>> attendanceAdminWeeks) {
    _appState?.attendanceAdminWeeks = attendanceAdminWeeks;
    notifyListeners();
  }

  void setAttendanceAdminTerms(
      List<Map<String, dynamic>> attendanceAdminTerms) {
    _appState?.attendanceAdminTerms = attendanceAdminTerms;
    notifyListeners();
  }

  void setCalendarView(Calendar calendarView) {
    _appState?.calendarView = calendarView;
    notifyListeners();
  }

  void setImagesView(ShowImage imagesView) {
    _appState?.imagesView = imagesView;
    notifyListeners();
  }
  // ----------------------------------------------------------------

  void setSocket(IO.Socket socket) {
    _appState?.socket = socket;
    notifyListeners();
  }

  // ----------------------------------------------------------------
  Future<void> restoreFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? breadcrumbs = prefs.getString('breadcrumbs');
    String? calendarViewString = prefs.getString('calendarView');
    String? imagesViewString = prefs.getString('imagesView');
    String? tableLengthString = prefs.getString('tableLength');
    String? currentPageString = prefs.getString('currentPage');
    String? rowsPerPageString = prefs.getString('rowsPerPage');
    String? studentsString = prefs.getString('students');
    String? classesString = prefs.getString('classes');
    String? schoolyearsString = prefs.getString('schoolyears');
    String? facultiesString = prefs.getString('faculties');
    String? lecturersString = prefs.getString('lecturers');
    String? subjectsString = prefs.getString('subjects');
    String? scheduleStudentWeeksString =
        prefs.getString('scheduleStudentWeeks');
    String? scheduleStudentTermsString =
        prefs.getString('scheduleStudentTerms');
    String? scheduleLecturerWeeksString =
        prefs.getString('scheduleLecturerWeeks');
    String? scheduleLecturerTermsString =
        prefs.getString('scheduleLecturerTerms');
    String? scheduleAdminTermsString = prefs.getString('scheduleAdminTerms');
    String? moduleTermByLecturerIDsString =
        prefs.getString('moduleTermByLecturerIDs');
// ----------------------------------------------------------------
    String? attendanceStudentTermsString =
        prefs.getString('attendanceStudentTerms');
    String? attendanceLecturerWeeksString =
        prefs.getString('attendanceLecturerWeeks');
    String? attendanceLecturerTermsString =
        prefs.getString('attendanceLecturerTerms');
    String? attendanceAdminWeeksString =
        prefs.getString('attendanceAdminWeeks');
    String? attendanceAdminTermsString =
        prefs.getString('attendanceAdminTerms');

    if (breadcrumbs != null &&
        calendarViewString != null &&
        imagesViewString != null &&
        tableLengthString != null &&
        currentPageString != null &&
        rowsPerPageString != null &&
        studentsString != null &&
        classesString != null &&
        schoolyearsString != null &&
        facultiesString != null &&
        lecturersString != null &&
        subjectsString != null &&
        scheduleStudentWeeksString != null &&
        scheduleStudentTermsString != null &&
        scheduleLecturerWeeksString != null &&
        scheduleLecturerTermsString != null &&
        scheduleAdminTermsString != null &&
        moduleTermByLecturerIDsString != null &&
        //----------------------------------------------------------------
        attendanceStudentTermsString != null &&
        attendanceLecturerWeeksString != null &&
        attendanceLecturerTermsString != null &&
        attendanceAdminWeeksString != null &&
        attendanceAdminTermsString != null) {
      Calendar calendarView = parseCalendar(calendarViewString);
      ShowImage imagesView = parseImagesView(imagesViewString);

      int tableLength = parseTableLength(tableLengthString);
      int currentPage = parseCurrentPage(currentPageString);
      int rowsPerPage = parseRowsPerPage(rowsPerPageString);

      List<Student> students = parseStudents(studentsString);
      List<Class> classes = parseClasses(classesString);
      List<Schoolyear> schoolyears = parseSchoolyears(schoolyearsString);
      List<Faculty> faculties = parseFaculties(facultiesString);
      List<Lecturer> lecturers = parseLecturers(lecturersString);
      List<Subject> subjects = parseSubjects(subjectsString);
      List<Map<String, dynamic>> scheduleStudentWeeks =
          parseScheduleStudentWeeks(scheduleStudentWeeksString);
      List<Map<String, dynamic>> scheduleStudentTerms =
          parseScheduleStudentTerms(scheduleStudentTermsString);
      List<Map<String, dynamic>> scheduleLecturerWeeks =
          parseScheduleLecturerWeeks(scheduleLecturerWeeksString);
      List<Map<String, dynamic>> scheduleLecturerTerms =
          parseScheduleLecturerTerms(scheduleLecturerTermsString);
      List<ScheduleAdminTerm> scheduleAdminTerms =
          parseScheduleAdminTerms(scheduleAdminTermsString);
      List<ModuleTermByLecturerID> moduleTermByLecturerIDs =
          parseModuleTermByLecturerIDs(moduleTermByLecturerIDsString);
// ----------------------------------------------------------------
      Map<String, dynamic> attendanceStudentTerms =
          parseAttendanceStudentTerms(attendanceStudentTermsString);
      Map<String, dynamic> attendanceLecturerWeeks =
          parseAttendanceLecturerWeeks(attendanceLecturerWeeksString);
      List<Map<String, dynamic>> attendanceLecturerTerms =
          parseAttendanceLecturerTerms(attendanceLecturerTermsString);
      List<Map<String, dynamic>> attendanceAdminWeeks =
          parseAttendanceAdminWeeks(attendanceAdminWeeksString);
      List<Map<String, dynamic>> attendanceAdminTerms =
          parseAttendanceAdminTerms(attendanceAdminTermsString);

      _appState = AppState(
        breadcrumbs: breadcrumbs,
        calendarView: calendarView,
        imagesView: imagesView,
        tableLength: tableLength,
        currentPage: currentPage,
        rowsPerPage: rowsPerPage,
        students: students,
        classes: classes,
        schoolyears: schoolyears,
        faculties: faculties,
        lecturers: lecturers,
        subjects: subjects,
        scheduleStudentWeeks: scheduleStudentWeeks,
        scheduleStudentTerms: scheduleStudentTerms,
        scheduleLecturerWeeks: scheduleLecturerWeeks,
        scheduleLecturerTerms: scheduleLecturerTerms,
        scheduleAdminTerms: scheduleAdminTerms,
        moduleTermByLecturerIDs: moduleTermByLecturerIDs,
        // ----------------------------------------------------------------
        attendanceStudentTerms: attendanceStudentTerms,
        attendanceLecturerWeeks: attendanceLecturerWeeks,
        attendanceLecturerTerms: attendanceLecturerTerms,
        attendanceAdminWeeks: attendanceAdminWeeks,
        attendanceAdminTerms: attendanceAdminTerms,
      );
      notifyListeners();
    }
  }

  Calendar parseCalendar(String calendarString) {
    Calendar parsedCalendar;

    if (calendarString == 'Calendar.week') {
      parsedCalendar = Calendar.week;
    } else if (calendarString == 'Calendar.term') {
      parsedCalendar = Calendar.term;
    } else {
      throw ArgumentError('Invalid calendar string: $calendarString');
    }

    return parsedCalendar;
  }

  ShowImage parseImagesView(String imagesString) {
    ShowImage parseImagesView;

    if (imagesString == 'ShowImage.full') {
      parseImagesView = ShowImage.full;
    } else if (imagesString == 'ShowImage.crop') {
      parseImagesView = ShowImage.crop;
    } else if (imagesString == 'ShowImage.video') {
      parseImagesView = ShowImage.video;
    } else {
      throw ArgumentError('Invalid images view string: $imagesString');
    }

    return parseImagesView;
  }
  //----------------------------------------------------------------

  int parseTableLength(String tableLengthString) {
    return int.parse(tableLengthString);
  }

  int parseCurrentPage(String currentPageString) {
    return int.parse(currentPageString);
  }

  int parseRowsPerPage(String rowsPerPageString) {
    return int.parse(rowsPerPageString);
  }

  //----------------------------------------------------------------

  List<Student> parseStudents(String studentsString) {
    return parseJsonList(studentsString, (json) => Student.fromMap(json));
  }

  List<Class> parseClasses(String classesString) {
    return parseJsonList(classesString, (json) => Class.fromMap(json));
  }

  List<Schoolyear> parseSchoolyears(String schoolyearsString) {
    return parseJsonList(schoolyearsString, (json) => Schoolyear.fromMap(json));
  }

  List<Faculty> parseFaculties(String facultiesString) {
    return parseJsonList(facultiesString, (json) => Faculty.fromMap(json));
  }

  List<Lecturer> parseLecturers(String lecturersString) {
    return parseJsonList(lecturersString, (json) => Lecturer.fromMap(json));
  }

  List<Subject> parseSubjects(String subjectsString) {
    return parseJsonList(subjectsString, (json) => Subject.fromMap(json));
  }

  // ----------------------------------------------------------------

  List<Map<String, dynamic>> parseScheduleStudentWeeks(
      String scheduleStudentWeeksString) {
    return parseJsonListOld(scheduleStudentWeeksString);
  }

  List<Map<String, dynamic>> parseScheduleStudentTerms(
      String scheduleStudentTermsString) {
    return parseJsonListOld(scheduleStudentTermsString);
  }

  List<Map<String, dynamic>> parseScheduleLecturerWeeks(
      String scheduleLecturerWeeksString) {
    return parseJsonListOld(scheduleLecturerWeeksString);
  }

  List<Map<String, dynamic>> parseScheduleLecturerTerms(
      String scheduleLecturerTermsString) {
    return parseJsonListOld(scheduleLecturerTermsString);
  }

  List<ScheduleAdminTerm> parseScheduleAdminTerms(
      String scheduleAdminTermsString) {
    return parseJsonList(
        scheduleAdminTermsString, (json) => ScheduleAdminTerm.fromMap(json));
  }

  List<ModuleTermByLecturerID> parseModuleTermByLecturerIDs(
      String moduleTermByLecturerIDsString) {
    return parseJsonList(moduleTermByLecturerIDsString,
        (json) => ModuleTermByLecturerID.fromMap(json));
  }

//----------------------------------------------------------------
  Map<String, dynamic> parseAttendanceStudentTerms(
      String attendanceStudentTermsString) {
    Map<String, dynamic> attendanceStudentTermsJson =
        jsonDecode(attendanceStudentTermsString);
    return attendanceStudentTermsJson;
  }

  Map<String, dynamic> parseAttendanceLecturerWeeks(
      String attendanceLecturerWeeksString) {
    List<dynamic> attendanceLecturerWeeksJson =
        jsonDecode(attendanceLecturerWeeksString);
    Map<String, dynamic> attendanceLecturerWeeks = {};
    for (var attendanceLecturerWeekJson in attendanceLecturerWeeksJson) {
      attendanceLecturerWeeks
          .addAll(Map<String, dynamic>.from(attendanceLecturerWeekJson));
    }
    return attendanceLecturerWeeks;
  }

  List<Map<String, dynamic>> parseAttendanceLecturerTerms(
      String attendanceLecturerTermsString) {
    return parseJsonListOld(attendanceLecturerTermsString);
  }

  List<Map<String, dynamic>> parseAttendanceAdminWeeks(
      String attendanceAdminWeeksString) {
    return parseJsonListOld(attendanceAdminWeeksString);
  }

  List<Map<String, dynamic>> parseAttendanceAdminTerms(
      String attendanceAdminTermsString) {
    return parseJsonListOld(attendanceAdminTermsString);
  }

  Future<void> saveToSharedPreferences(AppState appState) async {
    // lưu trữ state trong bộ nhớ cục bộ để state k bị mất khi reload trang
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('breadcrumbs', appState.breadcrumbs);
    prefs.setString('calendarView', appState.calendarView.toString());
    prefs.setString('imagesView', appState.imagesView.toString());
    prefs.setString('tableLength', appState.tableLength.toString());
    prefs.setString('currentPage', appState.currentPage.toString());
    prefs.setString('rowsPerPage', appState.rowsPerPage.toString());
    prefs.setString('students', appState.students.toString());
    prefs.setString('classes', appState.classes.toString());
    prefs.setString('schoolyears', appState.schoolyears.toString());
    prefs.setString('faculties', appState.faculties.toString());
    prefs.setString('lecturers', appState.lecturers.toString());
    prefs.setString('subjects', appState.subjects.toString());
    // ----------------------------------------------------------------
    prefs.setString(
        'scheduleStudentWeeks', appState.scheduleStudentWeeks.toString());
    prefs.setString(
        'scheduleStudentTerms', appState.scheduleStudentTerms.toString());
    prefs.setString(
        'scheduleLecturerWeeks', appState.scheduleLecturerWeeks.toString());
    prefs.setString(
        'scheduleLecturerTerms', appState.scheduleLecturerTerms.toString());
    prefs.setString(
        'scheduleAdminTerms', appState.scheduleAdminTerms.toString());
    prefs.setString(
        'moduleTermByLecturerIDs', appState.moduleTermByLecturerIDs.toString());
// --------------------------------------------------------------
    prefs.setString(
        'attendanceStudentTerms', appState.attendanceStudentTerms.toString());
    /* prefs.setString(
        'attendanceLecturerWeeks', appState.attendanceLecturerWeeks.toString()); */
    prefs.setString(
        'attendanceLecturerTerms', appState.attendanceLecturerTerms.toString());
    prefs.setString(
        'attendanceAdminWeeks', appState.attendanceAdminWeeks.toString());
    prefs.setString(
        'attendanceAdminTerms', appState.attendanceAdminTerms.toString());
  }

  void removePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('breadcrumbs');
    prefs.remove('calendarView');
    prefs.remove('imagesView');
    prefs.remove('tableLength');
    prefs.remove('currentPage');
    prefs.remove('rowsPerPage');
    prefs.remove('students');
    prefs.remove('classes');
    prefs.remove('schoolyears');
    prefs.remove('faculties');
    prefs.remove('lecturers');
    prefs.remove('subjects');
    //----------------------------------------------------------------
    prefs.remove('scheduleStudentWeeks');
    prefs.remove('scheduleStudentTerms');
    prefs.remove('scheduleLecturerWeeks');
    prefs.remove('scheduleLecturerTerms');
    prefs.remove('scheduleAdminWeeks');
    prefs.remove('scheduleAdminTerms');
    prefs.remove('moduleTermByLecturerIDs');
    // ----------------------------------------------------------------
    prefs.remove('attendanceStudentTerms');
    prefs.remove('attendanceLecturerWeeks');
    prefs.remove('attendanceLecturerTerms');
    prefs.remove('attendanceAdminTerms');

    print('removePrefs AppStateProvider');
  }
}
