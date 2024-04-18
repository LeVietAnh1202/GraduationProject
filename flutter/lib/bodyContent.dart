import 'package:flutter/material.dart';
import 'package:flutter_todo_app/breadcrumb.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/sidebar.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/singleChoice.dart';
import 'package:flutter_todo_app/students/dataTableStudent.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BodyContent extends StatefulWidget {
  late bool _haveContent = false;
  late Calendar calendarView;
  late String sidebarKey;

  BodyContent({super.key});

  @override
  State<BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  int currentPage = 1;
  int rowsPerPage = 10; // Số lượng hàng mỗi trang

  // late String dataTableScheduleKey;
  // String getDataTableScheduleKey(BuildContext context) {

  //   Map<String, String> roleMap = {
  //     "admin": "admin",
  //     "sinhvien": "student",
  //     "giangvien": "lecture"
  //   };

  //   return "${roleMap[role] ?? ''}${calendarView == Calendar.week ? 'Week' : 'Term'}";
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.calendarView = Provider.of<AppStateProvider>(context, listen: false)
    //     .appState!
    //     .calendarView;
    // print(widget.calendarView);
    // widget.sidebarKey = Provider.of<AppStateProvider>(context, listen: false)
    //     .appState!
    //     .breadcrumbs;
    // print(widget.sidebarKey);

    // widget.role =
    //     Provider.of<AccountProvider>(context, listen: false).account!.role;
    // // widget.role = '';
    // // widget.role = context.watch<AccountProvider>().account!.role;
    // print(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    widget.calendarView =
        context.watch<AppStateProvider>().appState!.calendarView;
    print('widget.calendarView: ');
    print(widget.calendarView);
    widget.sidebarKey = context.watch<AppStateProvider>().appState!.breadcrumbs;
    print(widget.sidebarKey);

    String role = context.watch<AccountProvider>().account!.role;
    SidebarMap sidebarMap =
        new SidebarMap(widget.calendarView, role, widget.sidebarKey, context);
    print('sidebarMap: ');
    print(sidebarMap);

    int numberOfPages = Provider.of<AppStateProvider>(context, listen: false).getNumberOfPages();

    return Container(
      width: MediaQuery.of(context).size.width - sideBarWidth,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Breadcrumb(),
          SizedBox(height: 16.0),
          if (widget.sidebarKey == quanLyLichHoc)
            SingleChoice(option: SegmentButtonOption.calendar),
          if (widget.sidebarKey == quanLyLichHoc) SizedBox(height: 16.0),
          Container(
            width: MediaQuery.of(context).size.width - sideBarWidth,
            // child: DtScheduleStudentTerm(),
            // child: DtScheduleLecturerTerm(),

            child: sidebarMap.containsKey()
                ? Container(
                    child: sidebarMap.getSidebarMap(),
                  )
                // ? DtScheduleStudentWeek()
                : DataTable(
                    columns: [
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Column 1',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Column 2',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Center(child: Text("234324242"))),
                          DataCell(Center(child: Text("31111114"))),
                        ],
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.first_page),
                onPressed: () {
                  // Handle pagination: Go to the first page
                  Provider.of<AppStateProvider>(context, listen: false)
                      .setCurrentPage(1);
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle pagination: Go to the previous page
                  Provider.of<AppStateProvider>(context, listen: false)
                      .goToPreviousPage();
                },
              ),
              SizedBox(width: 10),
              for (int currentPage = 1; currentPage <= numberOfPages; currentPage++)
                InkWell(
                    onTap: () {
                      // Handle pagination: Go to page i
                      Provider.of<AppStateProvider>(context, listen: false)
                          .setCurrentPage(currentPage);
                    },
                    child: currentPage ==
                            Provider.of<AppStateProvider>(context,
                                    listen: false)
                                .appState!
                                .currentPage
                        ? pageNumberBlock(
                            currentPage, Colors.blue, Colors.white)
                        : pageNumberBlock(
                            currentPage, Colors.white, Colors.black)),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // Handle pagination: Go to the next page
                  Provider.of<AppStateProvider>(context, listen: false)
                      .goToNextPage();
                },
              ),
              IconButton(
                icon: Icon(Icons.last_page),
                onPressed: () {
                  // Handle pagination: Go to the last page
                  Provider.of<AppStateProvider>(context, listen: false)
                      .goToLastPage();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container pageNumberBlock(int currentPage, Color bgrColor, Color textColor) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        color: bgrColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$currentPage',
        style: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
      ),
    );
  }
}
