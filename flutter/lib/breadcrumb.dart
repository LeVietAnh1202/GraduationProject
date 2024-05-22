import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/students/formAddStudent.dart';
import 'package:flutter_todo_app/timePicker.dart';
import 'package:provider/provider.dart';

class Breadcrumb extends StatefulWidget {
  Breadcrumb({super.key});

  @override
  State<Breadcrumb> createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<Breadcrumb> {
  @override
  Widget build(BuildContext context) {
    BuildContext mainContext = context;
    String breadcrumbs =
        context.watch<AppStateProvider>().appState!.breadcrumbs;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Text(
              'Trang chủ > ${context.watch<AppStateProvider>().appState?.breadcrumbs}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            DateTimePickerWidget(),
            (breadcrumbs == '$quanLyDanhMuc > $danhMucSinhVien')
                ? ElevatedButton(
                    onPressed: () {
                      // xử lý sự kiện
                      print(breadcrumbs);
                      if (breadcrumbs == '$quanLyDanhMuc > $danhMucSinhVien') {
                        showDialog(
                          context: mainContext,
                          builder: (BuildContext context) {
                            return FromAddStudent();
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Đổi màu xanh cho nút
                      padding: EdgeInsets.all(16.0), // Tăng kích thước của nút
                    ),
                    child: Text('Thêm'),
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
