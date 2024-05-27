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
  late String facultyID;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getfacultyID(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
  }

  Future<void> getfacultyID() async {
    final role = Provider.of<AccountProvider>(context, listen: false).getRole();
    print('role: ');
    print(role);
    List<Faculty>? faculties;
    if (role == Role.student) {
      faculties =
          await FacultyService.fetchFacultyByStudentID(context, (value) {
        setState(() {
          _isLoading = value;
        });
      });
      setState(() {
        facultyID = faculties![0].facultyID;
      });
    } else {
      _isLoading = false;
      setState(() {
        facultyID = 'utehy';
      });
    }
    // else if (role == Role.lecturer || role == Role.aao)
    // faculties = await FacultyService.fetchFacultyByLecturerID(context, (value) {});
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

    ListTile listTile(IconData? icon, String title) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        selected: _selectedItem == title,
        selectedTileColor: selectedSideBarItemColor,
        selectedColor: Colors.white,
        onTap: () {
          select(title);
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
                    ? CircularProgressIndicator()
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

            listTile(Icons.home, trangChu),
            listTile(Icons.schedule, quanLyLichHoc),
            listTile(Icons.task, quanLyDiemDanh),
            if (role == Role.admin || role == Role.aao)
              listTile(Icons.task, quanLyDinhDanh),
            if (role == Role.admin) listTile(Icons.book, 'Quản lý học phần'),

            if (role == Role.admin || role == Role.aao)
              ExpansionTile(
                leading: Icon(Icons.menu),
                title: Text('$quanLyDanhMuc'),
                children: [
                  if (role == Role.admin) listTile(null, danhMucKhoa),
                  listTile(null, '$quanLyDanhMuc > ${danhMucNganh}'),
                  listTile(null, '$quanLyDanhMuc > ${danhMucChuyenNganh}'),
                  listTile(null, '$quanLyDanhMuc > ${danhMucSinhVien}'),
                  listTile(null, '$quanLyDanhMuc > ${danhMucGiangVien}'),
                  listTile(null, '$quanLyDanhMuc > ${'Danh mục lớp'}'),
                  listTile(null, '$quanLyDanhMuc > ${'Danh mục môn học'}'),
                  listTile(null, '$quanLyDanhMuc > ${'Danh mục phòng'}'),
                  listTile(null, '$quanLyDanhMuc > ${'Danh mục thiết bị'}'),
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
