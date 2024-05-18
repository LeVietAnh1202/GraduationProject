import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/attendance_select_lecturer_term.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/faculties/dataTableFaculty.dart';
import 'package:flutter_todo_app/faculties/dataTableMajor.dart';
import 'package:flutter_todo_app/faculties/dataTableSpecialization.dart';
import 'package:flutter_todo_app/lecturers/dataTableLecturer.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/schedules/dtSchedule_Admin_Term.dart';
import 'package:flutter_todo_app/schedules/dtSchedule_Admin_Week.dart';
import 'package:flutter_todo_app/schedules/dtSchedule_Lecturer_Term.dart';

import 'package:flutter_todo_app/schedules/dtSchedule_Lecturer_Week.dart';
import 'package:flutter_todo_app/schedules/dtSchedule_Student_Term.dart';
import 'package:flutter_todo_app/schedules/dtSchedule_Student_Week.dart';
import 'package:flutter_todo_app/schedules/schedule_Admin_Widget.dart';
import 'package:flutter_todo_app/students/dataTableStudent.dart';
import 'package:provider/provider.dart';

class SidebarMap {
  late String dataTableScheduleKey;
  String sidebarMapKey;
  late Map<String, Widget> dataTableSchedule;
  late Map<String, Widget?> sidebarMap;
  Calendar calendarView;
  String role;
  BuildContext context;

  SidebarMap(this.calendarView, this.role, this.sidebarMapKey, this.context) {
    dataTableSchedule = {
      studentWeek: DtScheduleStudentWeek(),
      studentTerm: DtScheduleStudentTerm(),
      lecturerTerm: DtScheduleLecturerTerm(),
      lecturerWeek: DtScheduleLecturerWeek(),
      adminTerm: ScheduleAdminWidget(),
    };

    sidebarMap = {
      quanLyLichHoc: getDataTableSchedule(context),
      quanLyDinhDanh: DataTableStudent(),
      quanLyDiemDanh: ScheduleSelection(),
      '$quanLyDanhMuc > $danhMucSinhVien': DataTableStudent(),
      '$quanLyDanhMuc > $danhMucGiangVien': DataTableLecturer(),
      '$quanLyDanhMuc > $danhMucKhoa': DataTableFaculty(),
      '$quanLyDanhMuc > $danhMucNganh': DataTableMajor(),
      '$quanLyDanhMuc > $danhMucChuyenNganh': DataTableSpecialization(),
    };
  }

  Widget? getDataTableSchedule(BuildContext context) {
    Calendar calendarView =
        Provider.of<AppStateProvider>(context, listen: false)
            .appState!
            .calendarView;
    String role =
        Provider.of<AccountProvider>(context, listen: false).account!.role;
    Map<String, String> roleMap = {
      "admin": "admin",
      "aao": "aao",
      "sinhvien": "student",
      "giangvien": "lecturer"
    };

    dataTableScheduleKey =
        "${roleMap[role] ?? ''}${(roleMap[role] == 'admin' ? 'Term' : (calendarView == Calendar.week ? 'Week' : 'Term'))}";

    print('dataTableScheduleKey: ' + dataTableScheduleKey);

    return dataTableSchedule[dataTableScheduleKey];
  }

  bool containsKey() {
    print('ContainsKey');
    return sidebarMap.containsKey(sidebarMapKey);
  }

  Widget? getSidebarMap() {
    print('getSidebarMap');
    print(sidebarMap[sidebarMapKey]);
    return sidebarMap[sidebarMapKey];
  }
}
