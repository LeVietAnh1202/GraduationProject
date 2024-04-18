import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppState {
  String breadcrumbs;
  Calendar calendarView;
  ShowImage imagesView;
  int tableLength;
  int currentPage;
  int rowsPerPage;
  List<Map<String, dynamic>> students;
  List<Map<String, dynamic>> lecturers;
  List<Map<String, dynamic>> scheduleStudentWeeks;
  List<Map<String, dynamic>> scheduleStudentTerms;
  List<Map<String, dynamic>> scheduleLecturerWeeks;
  List<Map<String, dynamic>> scheduleLecturerTerms;
  List<Map<String, dynamic>> scheduleAdminWeeks;
  List<Map<String, dynamic>> scheduleAdminTerms;

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
    required this.lecturers,
    required this.scheduleStudentWeeks,
    required this.scheduleStudentTerms,
    required this.scheduleLecturerWeeks,
    required this.scheduleLecturerTerms,
    required this.scheduleAdminWeeks,
    required this.scheduleAdminTerms,
    required this.attendanceStudentTerms,
    required this.attendanceLecturerWeeks,
    required this.attendanceLecturerTerms,
    required this.attendanceAdminWeeks,
    required this.attendanceAdminTerms,
  }) {
    socket = IO.io(ULRNodeJSServer,
        IO.OptionBuilder().setTransports(['websocket']).build());
  }
}

class AppStateProvider with ChangeNotifier {
  AppState? _appState;

  AppState? get appState => _appState;

  AppStateProvider() {
    restoreFromSharedPreferences();
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
    _appState?.currentPage = (_appState!.tableLength / _appState!.rowsPerPage).ceil();
    notifyListeners();
  }

  int getNumberOfPages() {
    return (_appState!.tableLength / _appState!.rowsPerPage).ceil();
  }

  void setRowsPerPage(int rowsPerPage) {
    _appState?.rowsPerPage = rowsPerPage;
    notifyListeners();
  }

  void setStudents(List<Map<String, dynamic>> students) {
    _appState?.students = students;
    notifyListeners();
  }

  void setLecturers(List<Map<String, dynamic>> lecturers) {
    _appState?.lecturers = lecturers;
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

  void setScheduleAdminWeeks(List<Map<String, dynamic>> scheduleAdminWeeks) {
    _appState?.scheduleAdminWeeks = scheduleAdminWeeks;
    notifyListeners();
  }

  void setScheduleAdminTerms(List<Map<String, dynamic>> scheduleAdminTerms) {
    _appState?.scheduleAdminTerms = scheduleAdminTerms;
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
    String? lecturersString = prefs.getString('lecturers');
    String? scheduleStudentWeeksString =
        prefs.getString('scheduleStudentWeeks');
    String? scheduleStudentTermsString =
        prefs.getString('scheduleStudentTerms');
    String? scheduleLecturerWeeksString =
        prefs.getString('scheduleLecturerWeeks');
    String? scheduleLecturerTermsString =
        prefs.getString('scheduleLecturerTerms');
    String? scheduleAdminWeeksString = prefs.getString('scheduleAdminWeeks');
    String? scheduleAdminTermsString = prefs.getString('scheduleAdminTerms');
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
        lecturersString != null &&
        scheduleStudentWeeksString != null &&
        scheduleStudentTermsString != null &&
        scheduleLecturerWeeksString != null &&
        scheduleLecturerTermsString != null &&
        scheduleAdminWeeksString != null &&
        scheduleAdminTermsString != null &&
        //----------------------------------------------------------------
        attendanceStudentTermsString != null &&
        attendanceLecturerWeeksString != null &&
        attendanceLecturerTermsString != null &&
        attendanceAdminWeeksString != null &&
        attendanceAdminTermsString != null) {
      print("Calendar view:" + calendarViewString);
      Calendar calendarView = parseCalendar(calendarViewString);
      ShowImage imagesView = parseImagesView(imagesViewString);

      int tableLength = parseTableLength(tableLengthString);
      int currentPage = parseCurrentPage(currentPageString);
      int rowsPerPage = parseRowsPerPage(rowsPerPageString);

      List<Map<String, dynamic>> students = parseStudents(studentsString);
      List<Map<String, dynamic>> lecturers = parseLecturers(lecturersString);
      List<Map<String, dynamic>> scheduleStudentWeeks =
          parseScheduleStudentWeeks(scheduleStudentWeeksString);
      print('scheduleStudentWeeks restore: ');
      print(scheduleStudentWeeks);
      List<Map<String, dynamic>> scheduleStudentTerms =
          parseScheduleStudentTerms(scheduleStudentTermsString);
      List<Map<String, dynamic>> scheduleLecturerWeeks =
          parseScheduleLecturerWeeks(scheduleLecturerWeeksString);
      List<Map<String, dynamic>> scheduleLecturerTerms =
          parseScheduleLecturerTerms(scheduleLecturerTermsString);
      List<Map<String, dynamic>> scheduleAdminWeeks =
          parseScheduleAdminWeeks(scheduleAdminWeeksString);
      List<Map<String, dynamic>> scheduleAdminTerms =
          parseScheduleAdminTerms(scheduleAdminTermsString);
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
        lecturers: lecturers,
        scheduleStudentWeeks: scheduleStudentWeeks,
        scheduleStudentTerms: scheduleStudentTerms,
        scheduleLecturerWeeks: scheduleLecturerWeeks,
        scheduleLecturerTerms: scheduleLecturerTerms,
        scheduleAdminWeeks: scheduleAdminWeeks,
        scheduleAdminTerms: scheduleAdminTerms,
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
    } else {
      throw ArgumentError('Invalid calendar string: $imagesString');
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
    // Thực hiện chuyển đổi chuỗi thành danh sách sinh viên phù hợp
    // Ví dụ:
    return int.parse(rowsPerPageString);
  }

  //----------------------------------------------------------------

  List<Map<String, dynamic>> parseStudents(String studentsString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách sinh viên phù hợp
    // Ví dụ:
    List<dynamic> studentsJson = jsonDecode(studentsString);
    List<Map<String, dynamic>> students = [];
    for (var studentJson in studentsJson) {
      students.add(Map<String, dynamic>.from(studentJson));
    }
    return students;
  }

  List<Map<String, dynamic>> parseLecturers(String lecturersString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> lecturersJson = jsonDecode(lecturersString);
    List<Map<String, dynamic>> lecturers = [];
    for (var lecturerJson in lecturersJson) {
      lecturers.add(Map<String, dynamic>.from(lecturerJson));
    }
    return lecturers;
  }
  // ----------------------------------------------------------------

  List<Map<String, dynamic>> parseScheduleStudentWeeks(
      String scheduleStudentWeeksString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> scheduleStudentWeeksJson =
        jsonDecode(scheduleStudentWeeksString);
    List<Map<String, dynamic>> scheduleStudentWeeks = [];
    for (var scheduleStudentWeekJson in scheduleStudentWeeksJson) {
      scheduleStudentWeeks
          .add(Map<String, dynamic>.from(scheduleStudentWeekJson));
    }
    return scheduleStudentWeeks;
  }

  List<Map<String, dynamic>> parseScheduleStudentTerms(
      String scheduleStudentTermsString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> scheduleStudentTermsJson =
        jsonDecode(scheduleStudentTermsString);
    List<Map<String, dynamic>> scheduleStudentTerms = [];
    for (var scheduleStudentTermJson in scheduleStudentTermsJson) {
      scheduleStudentTerms
          .add(Map<String, dynamic>.from(scheduleStudentTermJson));
    }
    return scheduleStudentTerms;
  }

  List<Map<String, dynamic>> parseScheduleLecturerWeeks(
      String scheduleLecturerWeeksString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> scheduleLecturerWeeksJson =
        jsonDecode(scheduleLecturerWeeksString);
    List<Map<String, dynamic>> scheduleLecturerWeeks = [];
    for (var scheduleLecturerWeekJson in scheduleLecturerWeeksJson) {
      scheduleLecturerWeeks
          .add(Map<String, dynamic>.from(scheduleLecturerWeekJson));
    }
    return scheduleLecturerWeeks;
  }

  List<Map<String, dynamic>> parseScheduleLecturerTerms(
      String scheduleLecturerTermsString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> scheduleLecturerTermsJson =
        jsonDecode(scheduleLecturerTermsString);
    List<Map<String, dynamic>> scheduleLecturerTerms = [];
    for (var scheduleLecturerTermJson in scheduleLecturerTermsJson) {
      scheduleLecturerTerms
          .add(Map<String, dynamic>.from(scheduleLecturerTermJson));
    }
    return scheduleLecturerTerms;
  }

  List<Map<String, dynamic>> parseScheduleAdminWeeks(
      String scheduleAdminWeeksString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> scheduleAdminWeeksJson = jsonDecode(scheduleAdminWeeksString);
    List<Map<String, dynamic>> scheduleAdminWeeks = [];
    for (var scheduleAdminWeekJson in scheduleAdminWeeksJson) {
      scheduleAdminWeeks.add(Map<String, dynamic>.from(scheduleAdminWeekJson));
    }
    return scheduleAdminWeeks;
  }

  List<Map<String, dynamic>> parseScheduleAdminTerms(
      String scheduleAdminTermsString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> scheduleAdminTermsJson = jsonDecode(scheduleAdminTermsString);
    List<Map<String, dynamic>> scheduleAdminTerms = [];
    for (var scheduleAdminTermJson in scheduleAdminTermsJson) {
      scheduleAdminTerms.add(Map<String, dynamic>.from(scheduleAdminTermJson));
    }
    return scheduleAdminTerms;
  }

//----------------------------------------------------------------
  Map<String, dynamic> parseAttendanceStudentTerms(
      String attendanceStudentTermsString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> attendanceStudentTermsJson =
        jsonDecode(attendanceStudentTermsString);
    Map<String, dynamic> attendanceStudentTerms = {};
    for (var attendanceStudentTermJson in attendanceStudentTermsJson) {
      attendanceStudentTerms
          .addAll(Map<String, dynamic>.from(attendanceStudentTermJson));
    }
    return attendanceStudentTerms;
  }

  // List<Map<String, dynamic>> parseAttendanceLecturerWeeks(
  //     String attendanceLecturerWeeksString) {
  //   // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
  //   // Ví dụ:
  //   List<dynamic> attendanceLecturerWeeksJson =
  //       jsonDecode(attendanceLecturerWeeksString);
  //   List<Map<String, dynamic>> attendanceLecturerWeeks = [];
  //   for (var attendanceLecturerWeekJson in attendanceLecturerWeeksJson) {
  //     attendanceLecturerWeeks
  //         .add(Map<String, dynamic>.from(attendanceLecturerWeekJson));
  //   }
  //   return attendanceLecturerWeeks;
  // }

  Map<String, dynamic> parseAttendanceLecturerWeeks(
      String attendanceLecturerWeeksString) {
    // Perform the conversion from string to the appropriate lecturer weeks map
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
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> attendanceLecturerTermsJson =
        jsonDecode(attendanceLecturerTermsString);
    List<Map<String, dynamic>> attendanceLecturerTerms = [];
    for (var attendanceLecturerTermJson in attendanceLecturerTermsJson) {
      attendanceLecturerTerms
          .add(Map<String, dynamic>.from(attendanceLecturerTermJson));
    }
    return attendanceLecturerTerms;
  }

  List<Map<String, dynamic>> parseAttendanceAdminWeeks(
      String attendanceAdminWeeksString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> attendanceAdminWeeksJson =
        jsonDecode(attendanceAdminWeeksString);
    List<Map<String, dynamic>> attendanceAdminWeeks = [];
    for (var attendanceAdminWeekJson in attendanceAdminWeeksJson) {
      attendanceAdminWeeks
          .add(Map<String, dynamic>.from(attendanceAdminWeekJson));
    }
    return attendanceAdminWeeks;
  }

  List<Map<String, dynamic>> parseAttendanceAdminTerms(
      String attendanceAdminTermsString) {
    // Thực hiện chuyển đổi chuỗi thành danh sách giảng viên phù hợp
    // Ví dụ:
    List<dynamic> attendanceAdminTermsJson =
        jsonDecode(attendanceAdminTermsString);
    List<Map<String, dynamic>> attendanceAdminTerms = [];
    for (var attendanceAdminTermJson in attendanceAdminTermsJson) {
      attendanceAdminTerms
          .add(Map<String, dynamic>.from(attendanceAdminTermJson));
    }
    return attendanceAdminTerms;
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
    prefs.setString('lecturers', appState.lecturers.toString());
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
        'scheduleAdminWeeks', appState.scheduleAdminWeeks.toString());
    prefs.setString(
        'scheduleAdminTerms', appState.scheduleAdminTerms.toString());

// --------------------------------------------------------------
    prefs.setString(
        'attendanceStudentTerms', appState.attendanceStudentTerms.toString());
    prefs.setString(
        'attendanceLecturerWeeks', appState.attendanceLecturerWeeks.toString());
    prefs.setString(
        'attendanceLecturerTerms', appState.attendanceLecturerTerms.toString());
    prefs.setString(
        'attendanceAdminWeeks', appState.attendanceAdminWeeks.toString());
    prefs.setString(
        'attendanceAdminTerms', appState.attendanceAdminTerms.toString());
    // Lưu các trường khác nếu cần
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
    prefs.remove('lecturers');
    //----------------------------------------------------------------
    prefs.remove('scheduleStudentWeeks');
    prefs.remove('scheduleStudentTerms');
    prefs.remove('scheduleLecturerWeeks');
    prefs.remove('scheduleLecturerTerms');
    prefs.remove('scheduleAdminWeeks');
    prefs.remove('scheduleAdminTerms');
    // ----------------------------------------------------------------
    prefs.remove('attendanceStudentTerms');
    prefs.remove('attendanceLecturerWeeks');
    prefs.remove('attendanceLecturerTerms');
    prefs.remove('attendanceAdminWeeks');
    prefs.remove('attendanceAdminTerms');

    print('removePrefs AppStateProvider');
  }
}
