// import 'package:flutter/material.dart';
// import 'package:flutter_todo_app/attendance/utilities.dart';
// import 'package:flutter_todo_app/constant/string.dart';
// import 'package:intl/intl.dart';

// // ignore: must_be_immutable
// class DetailAttendanceStudentDayWidget extends StatefulWidget {
//   final String dayID;

//   const DetailAttendanceStudentDayWidget({required this.dayID});

//   @override
//   State<DetailAttendanceStudentDayWidget> createState() =>
//       _DetailAttendanceStudentDayWidgetState();
// }

// class _DetailAttendanceStudentDayWidgetState
//     extends State<DetailAttendanceStudentDayWidget> {
//   Map<String, String> extractPartsFromFilename(String imagePath) {
//     final regex =
//         RegExp(r'(\d{2})_(\d{4}-\d{2}-\d{2})_(\d{2}-\d{2}-\d{2})\.jpg');
//     final match = regex.firstMatch(imagePath.split('/').last);
//     if (match != null) {
//       final period = match.group(1); // Lấy 2 chữ số đầu là period
//       final dateTimeString =
//           match.group(2)! + ' ' + match.group(3)!; // Kết hợp ngày và thời gian
//       final parsedDateTime = DateFormat('yyyy-MM-dd HH-mm-ss')
//           .parse(dateTimeString); // Phân tích chuỗi thành đối tượng DateTime
//       final formattedTime = DateFormat('HH:mm:ss').format(
//           parsedDateTime); // Chuyển đổi đối tượng DateTime thành chuỗi hh:mm:ss
//       return {
//         'period': period ?? '',
//         'timestamp': formattedTime,
//       };
//     }
//     return {
//       'period': '',
//       'timestamp': '',
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 685,
//       height: 420,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 8),
//           Container(
//             padding: EdgeInsets.only(left: 15),
//             child: Column(children: [
//               Utilities.buildInfoRow('Thứ: ', ' ${widget.schedule['day']}'),
//               Utilities.buildInfoRow('Tiết: ', ' ${widget.schedule['time']}'),
//               Utilities.buildInfoRow(
//                   'Tên môn: ', ' ${widget.schedule['subjectName']}'),
//               Utilities.buildInfoRow(
//                   'Phòng học: ', ' ${widget.schedule['roomName']}'),
//               Utilities.buildInfoRow(
//                   'Tên giảng viên: ', ' ${widget.schedule['lecturerName']}'),
//             ]),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//               child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: (widget.schedule['attendance'] as List<dynamic>)
//                 .map((imagePath) {
//               final extractedParts = extractPartsFromFilename(imagePath);
//               final String? period = extractedParts['period'];
//               final String? timestamp = extractedParts['timestamp'];

//               return Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   children: [
//                     Image.network(
//                       '${URLNodeJSServer_Python_AttendanceImages}/${imagePath}',
//                       width: 140,
//                       height: 140,
//                       fit: BoxFit.cover,
//                     ),
//                     SizedBox(height: 8),
//                     Text('Tiết: $period'),
//                     Text('Thời gian: $timestamp'),
//                   ],
//                 ),
//               );
//             }).toList(),
//           )),
//         ],
//       ),
//     );
//   }
// }
