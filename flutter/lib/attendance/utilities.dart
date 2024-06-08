import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:intl/intl.dart';

class Utilities {
  static String formatDate(String inputDate) {
    // ignore: unused_local_variable
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    final outputFormat = DateFormat('dd/MM/yyyy');

    return outputFormat.format(inputFormat.parse(inputDate));
  }

  static String formatDateString(DateTime inputDate) {
    // ignore: unused_local_variable
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    final outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    return outputFormat.format(inputDate);
  }

  static Widget attendanceIcon(int? attendance) {
    return (attendance == null)
        ? Text('')
        : (attendance == 0)
            ? Icon(
                Icons.close,
                color: Colors.red[600],
                size: attendanceIconSize,
              )
            : (attendance == 1)
                ? Icon(
                    Icons.horizontal_rule,
                    color: Colors.amber[600],
                    size: attendanceIconSize,
                  )
                : Icon(
                    Icons.check,
                    color: Colors.green[600],
                    size: attendanceIconSize,
                  );
  }

  static Widget attendanceImages(int? NoImages) {
    return Container(
      alignment: Alignment.center,
      width: 50,
      height: 20,
      color: ((NoImages! / 4) <= 1 && (NoImages / 4) >= 0.8)
          ? Colors.green.shade200
          : ((NoImages / 4) >= 0.5
              ? Colors.amber.shade200
              : Colors.red.shade200),
      child: Text(
        '${NoImages.toString()}/4',
        // style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static String attendanceImagesToString(int? NoImages) {
    return '${NoImages.toString()}/4';
  }

  static String attendanceString(int? attendance) {
    return (attendance == null)
        ? ''
        : (attendance == 0)
            ? 'x'
            : (attendance == 1)
                ? '-'
                : 'v';
  }

  static TextButton exportFileButton(Function()? onPressFunction) {
    return TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Đổi màu xanh cho nút
          padding: EdgeInsets.all(16.0), // Tăng kích thước của nút
        ),
        child: Text(
          'Xuất file',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPressFunction);
  }

  // Hàm tìm vị trí của dấu \ thứ n trong chuỗi
  static int nthIndexOf(String str, String char, int n) {
    int count = 0;
    for (int i = 0; i < str.length; i++) {
      if (str[i] == char) {
        count++;
        if (count == n) {
          return i;
        }
      }
    }
    return -1;
  }

  static String formatImageTime(String imageTime) {
    print('imageTime ${imageTime}');
    // Tìm vị trí của dấu \ thứ tư
    int fourthBackslashIndex = nthIndexOf(imageTime, '/', 2);
    // int fourthBackslashIndex = nthIndexOf(imageTime, '\\', 2);
    if (fourthBackslashIndex == -1) {
      print("Không tìm thấy dấu \\ thứ tư.");
      return '';
    }

    // Tìm vị trí của dấu . đầu tiên sau dấu \ thứ tư
    int dotIndex = imageTime.indexOf('.', fourthBackslashIndex);
    if (dotIndex == -1) {
      print("Không tìm thấy dấu . sau dấu \\ thứ tư.");
      return '';
    }

    // Cắt chuỗi từ dấu \ thứ tư đến trước dấu .
    String stringSplited =
        imageTime.substring(fourthBackslashIndex + 3, dotIndex);
    // imageTime.substring(fourthBackslashIndex + 1, dotIndex);
    print('stringSplited ${stringSplited}');

    // Tìm vị trí của dấu - thứ ba
    int thirdDashIndex = nthIndexOf(stringSplited, '-', 3);
    int fourDashIndex = nthIndexOf(stringSplited, '-', 4);
    if (thirdDashIndex == -1) {
      print("Không tìm thấy dấu - thứ ba.");
      return '';
    }

    // Thay thế dấu - thứ ba bằng dấu :
    String result = stringSplited.substring(0, thirdDashIndex) +
        ':' +
        stringSplited.substring(thirdDashIndex + 1, fourDashIndex) +
        ':' +
        stringSplited.substring(fourDashIndex + 1);
    print('result ${result}');

    // Chuyển đổi từ chuỗi sang đối tượng DateTime
    DateTime dateTime = DateTime.parse(result.replaceAll('_', 'T'));

    // Định dạng lại ngày giờ theo yêu cầu
    String formattedDate = DateFormat('HH:mm:ss').format(dateTime);
    // String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  static Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 140, // Độ rộng cố định cho nhãn
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
