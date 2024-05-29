import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/provider/account.dart';
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
    final role =
        Provider.of<AccountProvider>(context, listen: false).getRole();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.watch<AppStateProvider>().appState?.breadcrumbs ==
                      'Trang chủ'
                  ? ''
                  : 'Trang chủ > ${context.watch<AppStateProvider>().appState?.breadcrumbs}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            if (breadcrumbs == quanLyLichHoc || breadcrumbs == quanLyDiemDanh)
              DateTimePickerWidget(),
            (breadcrumbs == quanLyDinhDanh && role == Role.aao)
                ? ElevatedButton(
                    onPressed: () {
                      // if (breadcrumbs == '$quanLyDanhMuc > $danhMucSinhVien') 
                        showDialog(
                          context: mainContext,
                          builder: (BuildContext context) {
                            return FromAddStudent();
                          },
                        );
                      
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
