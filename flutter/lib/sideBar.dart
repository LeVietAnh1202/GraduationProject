import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AccountProvider>().getRole();

    return Container(
      // width: _isSidebarCollapsed ? 60 : 200,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            //   child: Text(
            //     'Quản lý điểm danh',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 24,
            //     ),
            //   ),
            // ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text(quanLyLichHoc),
              onTap: () {
                context.read<AppStateProvider>().setBreadcrumbs(quanLyLichHoc);
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text(quanLyDinhDanh),
              onTap: () {
                context.read<AppStateProvider>().setBreadcrumbs(quanLyDinhDanh);
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text(quanLyDiemDanh),
              onTap: () {
                context.read<AppStateProvider>().setBreadcrumbs(quanLyDiemDanh);
              },
            ),
            if (role == 'admin' || role == 'aao')
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Quản lý học phần'),
                onTap: () {
                  context
                      .read<AppStateProvider>()
                      .setBreadcrumbs('Quản lý học phần');
                },
              ),

            if (role == 'admin' || role == 'aao')
              ExpansionTile(
                leading: Icon(Icons.menu),
                title: Text('$quanLyDanhMuc'),
                children: [
                  if (role == 'admin')
                    ListTile(
                      // leading: Icon(Icons.account_balance),
                      title: Text(danhMucKhoa),
                      onTap: () {
                        context
                            .read<AppStateProvider>()
                            .setBreadcrumbs('$quanLyDanhMuc > $danhMucKhoa');
                      },
                    ),
                    ListTile(
                      // leading: Icon(Icons.account_balance),
                      title: Text(danhMucNganh),
                      onTap: () {
                        context
                            .read<AppStateProvider>()
                            .setBreadcrumbs('$quanLyDanhMuc > $danhMucNganh');
                      },
                    ),
                    ListTile(
                      // leading: Icon(Icons.account_balance),
                      title: Text(danhMucChuyenNganh),
                      onTap: () {
                        context
                            .read<AppStateProvider>()
                            .setBreadcrumbs('$quanLyDanhMuc > $danhMucChuyenNganh');
                      },
                    ),
                  ListTile(
                    title: Text(danhMucSinhVien),
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .setBreadcrumbs('$quanLyDanhMuc > $danhMucSinhVien');
                    },
                  ),
                  ListTile(
                    title: Text(danhMucGiangVien),
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .setBreadcrumbs('$quanLyDanhMuc > $danhMucGiangVien');
                    },
                  ),
                  ListTile(
                    title: Text('Danh mục lớp'),
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .setBreadcrumbs('$quanLyDanhMuc > Danh mục lớp');
                    },
                  ),
                  ListTile(
                    title: Text('Danh mục môn học'),
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .setBreadcrumbs('$quanLyDanhMuc > Danh mục môn học');
                    },
                  ),
                  ListTile(
                    title: Text('Danh mục phòng'),
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .setBreadcrumbs('$quanLyDanhMuc > Danh mục phòng');
                    },
                  ),
                  ListTile(
                    title: Text('Danh mục thiết bị'),
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .setBreadcrumbs('$quanLyDanhMuc > Danh mục thiết bị');
                    },
                  ),
                  // Add other dropdown items as needed
                ],
              ),

            // ListTile(
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
            //     onTap: () {
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
