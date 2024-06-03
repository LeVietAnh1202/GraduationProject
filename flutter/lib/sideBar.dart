import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/color.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/faculties/facultyService.dart';
import 'package:flutter_todo_app/model/facultyModel.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // bool _isSidebarCollapsed = false;
  String _selectedItem = trangChu;
  late String facultyID = 'utehy';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final role =
          Provider.of<AccountProvider>(context, listen: false).getRole();
      if (role != Role.admin)
        getfacultyID(role!);
      else
        _setLoading(false);
    });
  }

  Future<void> getfacultyID(Role role) async {
    List<Faculty>? faculties;
    if (role == Role.lecturer || role == Role.aao) {
      faculties = await FacultyService.fetchFaculties(context, _setLoading);
    } else if (role == Role.student) {
      faculties =
          await FacultyService.fetchFacultyByStudentID(context, _setLoading);
    }
    setState(() {
      facultyID = faculties![0].facultyID;
    });
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AccountProvider>().getRole();

    void select(String item) {
      context.read<AppStateProvider>().setBreadcrumbs(item);
      setState(() {
        _selectedItem = item;
      });
    }

    ListTile listTile(IconData? icon, bool isCategory, String title) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        selected: _selectedItem == title,
        selectedTileColor: selectedSideBarItemColor,
        selectedColor: Colors.white,
        onTap: () {
          isCategory ? select('$quanLyDanhMuc > ${title}') : select(title);
        },
      );
    }

    return Container(
      // width: _isSidebarCollapsed ? 60 : 200,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                // decoration: BoxDecoration(
                //   color: Colors.grey.shade300,
                // ),
                margin: EdgeInsets.zero,
                child: _isLoading
                    ? Center(
                        child: Container(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator()))
                    : Image.asset(
                        'assets/images/logo/${facultyID}.png',
                        width: 25,
                      )
                // Text(
                //   'Quản lý điểm danh',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 24,
                //   ),
                // ),
                ),

            listTile(Icons.home, false, trangChu),
            listTile(Icons.schedule, false, quanLyLichHoc),
            listTile(Icons.task, false, quanLyDiemDanh),
            if (role == Role.admin || role == Role.aao)
              listTile(Icons.task, false, quanLyDinhDanh),
            if (role == Role.admin)
              listTile(Icons.book, false, 'Quản lý học phần'),

            if (role == Role.admin || role == Role.aao)
              ExpansionTile(
                leading: Icon(Icons.menu),
                title: Text('$quanLyDanhMuc'),
                children: [
                  if (role == Role.admin) listTile(null, true, danhMucKhoa),
                  listTile(null, true, danhMucNganh),
                  listTile(null, true, danhMucChuyenNganh),
                  listTile(null, true, danhMucSinhVien),
                  listTile(null, true, danhMucGiangVien),
                  listTile(null, true, 'Danh mục lớp'),
                  listTile(null, true, 'Danh mục môn học'),
                  listTile(null, true, 'Danh mục phòng'),
                  listTile(null, true, 'Danh mục thiết bị'),
                  // Add other dropdown items as needed
                ],
              ),

            // ListTgile(
            //     leading: _isSidebarCollapsed
            //         ? IconButton(
            //             icon: Icon(Icons.arrow_forward),
            //             onPressed: () {
            //               setState(() {
            //                 _isSidebarCollapsed = !_isSidebarCollapsed;
            //               });
            //             },
            //           )
            //         : IconButton(
            //             icon: Icon(Icons.arrow_forward),
            //             onPressed: () {
            //               setState(() {
            //                 _isSidebarCollapsed = !_isSidebarCollapsed;
            //               });
            //             },
            //           ),
            //     title: _isSidebarCollapsed ? null : Text('Quản lý điểm danh'),
            //selectedTileColor: selectedSideBarItemColor,
            //onTap: () {
            //       // Handle sidebar item click
            //     },
            //   ),
            // Add other sidebar items as needed
          ],
        ),
      ),
    );
  }
}
