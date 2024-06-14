import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/constant/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DateTimePickerWidget extends StatefulWidget {
  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime _selectedDateTime;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    // socket = Provider.of<AppStateProvider>(context, listen: false).appState!.socket;
    // socket.emit('currentTime', _selectedDateTime.toString());
    Future.delayed(Duration.zero, () {
      changeSimulationDate(_selectedDateTime);
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          print(_selectedDateTime.toString());
          // socket.emit('currentTime', _selectedDateTime.toString());
          changeSimulationDate(_selectedDateTime);
        });
      }
    }
  }

  static Future<String> changeSimulationDateService(DateTime date) async {
    final response = await http.post(
      Uri.http(url, changeSimulationDateAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'simulationDate': date.toString()}),
    );
    return json.encode({
      'message': json.decode(response.body)['message'],
      'statusCode': response.statusCode
    });
  }

  Future<void> changeSimulationDate(DateTime date) async {
    final response = json.decode(await changeSimulationDateService(date));
    if (response['statusCode'] == 200) {
      // Xử lý thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor:
              Colors.green, // Thay đổi màu nền thành màu xanh lá cây
        ),
      );
    } else {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${response['statusCode']}: ${response['message']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          Utilities.formatDateString(_selectedDateTime),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _selectDateTime(context),
          child: Text('Thay đổi thời gian mô phỏng'),
        ),
      ],
    );
  }
}
