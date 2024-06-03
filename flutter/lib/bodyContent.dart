import 'package:flutter/material.dart';
import 'package:flutter_todo_app/breadcrumb.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/sidebar.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/pageNumber.dart';
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
            PageNumberWidget()
        ],
      ),
    );
  }

  
}
