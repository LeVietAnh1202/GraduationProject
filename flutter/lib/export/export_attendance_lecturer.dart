// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:path/path.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter_todo_app/attendance/utilities.dart';

// class ExportExcel {
//   static Future<void> exportAttendanceLecturerTermToExcel(
//       List<Map<String, dynamic>> attendances) async {
//     // Tạo một workbook mới
//     final workbook = Excel.createExcel();

//     // Tạo một sheet trong workbook
//     final sheet = workbook['Sheet1'];

//     // Thiết lập tiêu đề cho các cột trong sheet
//     sheet.appendRow([
//       TextCellValue('STT'),
//       TextCellValue('Họ và tên'),
//       TextCellValue('Số buổi đúng giờ'),
//       TextCellValue('Số buổi đi muộn'),
//       TextCellValue('Số buổi nghỉ'),
//       ...(attendances.first['dateList'] as List<dynamic>)
//           // .map((element) => TextCellValue(element)),
//           .map((element) => TextCellValue(element.toString())),
//     ]);

//     // Thêm dữ liệu từ DataTable vào sheet
//     for (final attendance in attendances) {
//       final row = [
//         TextCellValue((attendances.indexOf(attendance) + 1).toString()),
//         TextCellValue(attendance['studentName']),
//         ...(attendance['dateList'] as List<dynamic>).map((entry) {
//           return TextCellValue(
//               Utilities.attendanceIcon(entry.values.first).toString());
//         }).toList(),
//         TextCellValue(attendance['numberOfOnTimeSessions'].toString()),
//         TextCellValue(attendance['numberOfLateSessions'].toString()),
//         TextCellValue(attendance['numberOfBreaksSessions'].toString()),
//       ];

//       sheet.appendRow(row);
//     }
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
//     if (result == null) {
//       print('No file selected');
//       return;
//     }
//     String outputFile = result.files.single.path!;
//     // var excel = Excel.createExcel();
//     // String outputFile =
//     //     "C:\\Users\\MinhDoanh\\Downloads\\attendanceLecturerTerm.xlsx";

//     //stopwatch.reset();
//     List<int>? fileBytes = workbook.save();
//     //print('saving executed in ${stopwatch.elapsed}');
//     if (fileBytes != null) {
//       File(join(outputFile))
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(fileBytes);
//     }
//   }
// }

import 'package:excel/excel.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'package:flutter_todo_app/model/moduleTermByLecturerIDModel.dart';

class ExportExcel {
  static Future<void> exportAttendanceLecturerTermToExcel(
      // List<ModuleTermByLecturerID> attendances,
      List<Map<String, dynamic>> attendances,
      String subjectName,
      String classCode) async {
    // Tạo một workbook mới
    final workbook = Excel.createExcel();

    // Tạo một sheet trong workbook
    final sheet = workbook['Sheet1'];

    sheet.cell(CellIndex.indexByString('A2')).value =
        TextCellValue('Lớp: ${classCode}');

    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('');
    // Thiết lập tiêu đề cho các cột trong sheet
    sheet.appendRow([
      TextCellValue('STT'),
      TextCellValue('Họ và tên'),
      ...(attendances.first['dateList'] as List<dynamic>).map(
          (element) => TextCellValue(Utilities.formatDate(element.keys.first))
          //     (element) {
          //   // final cell = TextCellValue('1');
          //   final cell = TextCellValue(Utilities.formatDate(element.keys.first));
          //   final columnIndex = attendances.first['dateList'].indexOf(element);
          //   final cellIndex = CellIndex.indexByColumnRow(
          //       columnIndex: columnIndex + 2, rowIndex: 3);
          //   final excelCell = sheet.cell(cellIndex);
          //   excelCell.value = cell;
          //   excelCell.cellStyle?.rotation = 90;
          //   return cell;
          // }
          ),
      TextCellValue('Số ảnh điểm danh/Tổng số tiết'),
    ]);

    // Thêm dữ liệu từ DataTable vào sheet
    for (final attendance in attendances) {
      print((attendances.indexOf(attendance) + 1).toString());
      final row = [
        IntCellValue((attendances.indexOf(attendance) + 1)),
        TextCellValue(attendance['studentName']),
        ...(attendance['dateList'] as List<dynamic>).map((entry) {
          var date = entry.keys.first;
          return TextCellValue(
              Utilities.attendanceImagesToString(entry[date]['NoImages']));
        }).toList(),
      ];

      row.add(
        TextCellValue(
            '${(attendance['NoImagesValid'] == 0 ? '-' : attendance['NoImagesValid']).toString()}/${attendance['numberOfLessons']}'),
      );

      sheet.appendRow(row);

      // [4, 5, 6].forEach((columnIndex) {
      //   final cell = sheet.cell(CellIndex.indexByColumnRow(
      //       columnIndex: columnIndex, rowIndex: sheet.maxRows - 1));
      //   cell.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
      // });
    }

    final fileBytes =
        workbook.save(fileName: 'DiemDanhHP_${subjectName}_${classCode}.xlsx');

    if (fileBytes == null) {
      print('Failed to generate Excel file');
    }

    // if (fileBytes != null) {
    //   final data = Uint8List.fromList(fileBytes);

    //   // FileSaver.instance.saveFile(
    //   //   name: 'DiemDanhHP_${subjectName}_${classCode}.xlsx',
    //   //   bytes: data,
    //   // );
    // } else {
    //   print('Failed to generate Excel file');
    // }
  }

  static Future<void> exportAttendanceLecturerWeekToExcel(
      Map<String, dynamic> attendances,
      String subjectName,
      String classCode,
      String week,
      String day,
      String time) async {
    // Tạo một workbook mới
    final workbook = Excel.createExcel();

    // Tạo một sheet trong workbook
    final sheet = workbook['Sheet1'];

    sheet.cell(CellIndex.indexByString('A2')).value =
        TextCellValue('Lớp: ${classCode}');

    sheet.cell(CellIndex.indexByString('A3')).value =
        TextCellValue('Tuần: ${week}');
    sheet.cell(CellIndex.indexByString('B3')).value =
        TextCellValue('Thứ: ${day}');
    sheet.cell(CellIndex.indexByString('C3')).value =
        TextCellValue('Tiết: ${time}');
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('');
    // Thiết lập tiêu đề cho các cột trong sheet
    sheet.appendRow([
      TextCellValue('STT'),
      TextCellValue('Họ và tên'),
      TextCellValue('Điểm danh'),

      //     (element) {
      //   final cell = TextCellValue('1');
      //   // final cell = TextCellValue(Utilities.formatDate(element.keys.first));
      //   final columnIndex = attendances.first['dateList'].indexOf(element);
      //   final cellIndex = CellIndex.indexByColumnRow(
      //       columnIndex: columnIndex + 2, rowIndex: 3);
      //   final excelCell = sheet.cell(cellIndex);
      //   excelCell.value = cell;
      //   excelCell.cellStyle?.rotation = 90;
      //   return cell;
      // }
    ]);
    int index = 0; // Biến đếm số thứ tự
    // Thêm dữ liệu từ DataTable vào sheet
    for (final attendance in attendances['studentAttendance']) {
      final row = [
        TextCellValue((++index).toString()),
        // TextCellValue(attendance.keys.first),
        // TextCellValue(Utilities.attendanceString(attendance.values.first)),
        TextCellValue(attendance['studentName']),
        ...(attendance['dateList'] as List<dynamic>).map((entry) {
          var date = entry.keys.first;
          return TextCellValue(
              Utilities.attendanceImagesToString(entry[date]['NoImages']));
        }).toList(),
      ];

      sheet.appendRow(row);

      // [4, 5, 6].forEach((columnIndex) {
      //   final cell = sheet.cell(CellIndex.indexByColumnRow(
      //       columnIndex: columnIndex, rowIndex: sheet.maxRows - 1));
      //   cell.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
      // });
    }

    final fileBytes = workbook.save(
        fileName: 'DiemDanhTuan_${subjectName}_${classCode}.xlsx');

    if (fileBytes == null) {
      print('Failed to generate Excel file');
    }
  }
}
