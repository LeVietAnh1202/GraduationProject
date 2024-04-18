import 'package:excel/excel.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';

class ExportExcel {
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
        TextCellValue(attendance.keys.first),
        TextCellValue(Utilities.attendanceString(attendance.values.first)),
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
