import 'package:flutter/material.dart';
import 'package:flutter_todo_app/breadcrumb.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/sidebar.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/processingAndTraining.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/singleChoice.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BodyContent extends StatefulWidget {
  late Calendar calendarView;
  late String sidebarKey;

  BodyContent({super.key});

  @override
  State<BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  int currentPage = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.calendarView =
        context.watch<AppStateProvider>().appState!.calendarView;
    widget.sidebarKey = context.watch<AppStateProvider>().appState!.breadcrumbs;

    Role? role = context.watch<AccountProvider>().getRole();
    SidebarMap sidebarMap =
        new SidebarMap(widget.calendarView, role, widget.sidebarKey, context);

    int numberOfPages = Provider.of<AppStateProvider>(context, listen: false)
        .getNumberOfPages();

    return Container(
      width: MediaQuery.of(context).size.width - sideBarWidth,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Breadcrumb(),
          SizedBox(height: 16.0),
          if (widget.sidebarKey == quanLyLichHoc &&
              role != Role.admin &&
              role != Role.lecturer &&
              role != Role.aao)
            SingleChoice(
                option: SegmentButtonOption.calendar,
                changeImageOption: (_) {}),
          if (widget.sidebarKey == quanLyLichHoc) SizedBox(height: 16.0),
          Container(
              width: MediaQuery.of(context).size.width - sideBarWidth,

              child: sidebarMap.containsKey()
                  ? Container(
                      child: sidebarMap.getSidebarMap(),
                    )
                  : ProcessingAndTraining()
              ),
          SizedBox(height: 16.0),
          if (widget.sidebarKey == quanLyDinhDanh ||
              widget.sidebarKey == '$quanLyDanhMuc > $danhMucSinhVien' ||
              widget.sidebarKey == '$quanLyDanhMuc > $danhMucKhoa' ||
              widget.sidebarKey == '$quanLyDanhMuc > $danhMucNganh' ||
              widget.sidebarKey == '$quanLyDanhMuc > $danhMucChuyenNganh' ||
              widget.sidebarKey == '$quanLyDanhMuc > $danhMucGiangVien')
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
                for (int currentPage = 1;
                    currentPage <= numberOfPages;
                    currentPage++)
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
