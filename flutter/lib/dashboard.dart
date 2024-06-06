import 'package:flutter/material.dart';
import 'package:flutter_todo_app/accountDropdown.dart';
import 'package:flutter_todo_app/bodyContent.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/sideBar.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userName;
  late IO.Socket socket;
  double fingerID = 0.0;
  double confidence = 0.0;
  String time = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppState appState = AppState(
      breadcrumbs: trangChu,
      tableLength: 0,
      currentPage: 1,
      rowsPerPage: rowsPerPage,
      students: [],
      classes: [],
      schoolyears: [],
      faculties: [],
      lecturers: [],
      subjects: [],
      calendarView: Calendar.week,
      imagesView: ShowImage.video,
      scheduleStudentWeeks: [],
      scheduleStudentTerms: [],
      scheduleLecturerWeeks: [],
      scheduleLecturerTerms: [],
      scheduleAdminTerms: [],
      moduleTermByLecturerIDs: [],
      attendanceStudentByDayIDs: [],
      // - - - - - - - - - - - - - - - -
      attendanceStudentTerms: {},
      attendanceLecturerWeeks: {},
      attendanceLecturerTerms: [],
      attendanceAdminWeeks: [],
      attendanceAdminTerms: [],
    );
    Future.delayed(Duration.zero, () {
      Provider.of<AppStateProvider>(context, listen: false)
          .setAppState(appState);
    });

    // connectAndListen();
  }

  void connectAndListen() {
    print('Call func connectAndListen');
    // socket = IO.io('${URLPythonServer}/socket.io',
    // socket = IO.io('ws://192.168.1.106:8001',
    //     IO.OptionBuilder().setTransports(['websocket']).build());

    socket = IO.io('http://192.168.1.106:8001', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });

    socket.onConnect((_) {
      print('connect');
      socket.emit('fromClient', 'test from client');
    });

    // socket.on('attendance', (data) {
    //   print('Received data: $data');
    //   setState(() {
    //     fingerID = data['fingerID'].toDouble();
    //     confidence = data['confidence'].toDouble();
    //     time = data['time'];
    //   });
    // });

    socket.onDisconnect((reason) {
      print('Disconnected: $reason');
    });

    // //When an event recieved from server, data is added to the stream
    // socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Row(
          children: [
            Image.asset(
              // 'assets/images/face_recognition_dynamic.gif',
              'assets/images/logoHome.jpg',
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Hệ thống quản lý điểm danh sinh viên'.toUpperCase(),
              style: TextStyle(letterSpacing: 1.5, wordSpacing: 1.7),
            ),
            // Text('fingerID: ${fingerID.toString()} - confidence: ${confidence.toString()} - time: ${time}'),
          ],
        ),
        actions: [
          AccountDropdown(),
        ],
      ),
      body: Row(
        children: [Sidebar(), BodyContent()],
      ),
    );
  }
}
