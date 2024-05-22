import 'package:flutter/material.dart';

class FixedColumnDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  FixedColumnDataTable({required this.data});

  @override
  _FixedColumnDataTableState createState() => _FixedColumnDataTableState();
}

class _FixedColumnDataTableState extends State<FixedColumnDataTable> {
  late ScrollController _verticalScrollController;
  late ScrollController _fixedColumnScrollController;
  late ScrollController _scrollableColumnScrollController;

  @override
  void initState() {
    super.initState();
    _verticalScrollController = ScrollController();
    _fixedColumnScrollController = ScrollController();
    _scrollableColumnScrollController = ScrollController();

    // Synchronize the scrolling of the fixed column and scrollable column
    _verticalScrollController.addListener(() {
      _fixedColumnScrollController.jumpTo(_verticalScrollController.offset);
      _scrollableColumnScrollController
          .jumpTo(_verticalScrollController.offset);
    });
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _fixedColumnScrollController.dispose();
    _scrollableColumnScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _verticalScrollController,
      scrollDirection: Axis.vertical,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Columns
          SingleChildScrollView(
            controller: _fixedColumnScrollController,
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'STT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Họ và tên',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: widget.data
                  .asMap()
                  .entries
                  .map(
                    (entry) => DataRow(
                      cells: [
                        DataCell(Text((entry.key + 1).toString())),
                        DataCell(Text(entry.value['studentName'])),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          // Scrollable Columns
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollableColumnScrollController,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    ...widget.data.first['dateList'].map<DataColumn>((entry) {
                      return DataColumn(
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Utilities.formatDate(entry.keys.first),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Tiết 1-4',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Thông tin chi tiết'),
                                      content: Text(
                                          'Chi tiết điểm danh cho ngày ${Utilities.formatDate(entry.keys.first)}.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Đóng'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    DataColumn(
                      label: Text(
                        'Số buổi\nđúng giờ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Số buổi\nđi muộn',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Số buổi\nnghỉ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: widget.data
                      .map(
                        (attendance) => DataRow(
                          cells: [
                            ...attendance['dateList'].map<DataCell>((entry) {
                              return DataCell(Center(
                                child: Utilities.attendanceIcon(
                                    entry.values.first),
                              ));
                            }).toList(),
                            DataCell(Center(
                                child: Text(
                                    (attendance['numberOfOnTimeSessions'] == 0
                                            ? '-'
                                            : attendance[
                                                'numberOfOnTimeSessions'])
                                        .toString()))),
                            DataCell(Center(
                                child: Text(
                                    (attendance['numberOfLateSessions'] == 0
                                            ? '-'
                                            : attendance[
                                                'numberOfLateSessions'])
                                        .toString()))),
                            DataCell(Center(
                                child: Text(
                                    (attendance['numberOfBreaksSessions'] == 0
                                            ? '-'
                                            : attendance[
                                                'numberOfBreaksSessions'])
                                        .toString()))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Utilities {
  static String formatDate(String date) {
    // Implement the date formatting logic
    return date;
  }

  static Widget attendanceIcon(String status) {
    // Implement the logic to return the appropriate icon based on the attendance status
    return Icon(Icons.check_circle);
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Fixed Column Data Table')),
      body: FixedColumnDataTable(
        data: [
          {
            'studentName': 'Nguyen Van A',
            'dateList': [
              {'2023-05-01': 'present'},
              {'2023-05-02': 'absent'},
            ],
            'numberOfOnTimeSessions': 10,
            'numberOfLateSessions': 2,
            'numberOfBreaksSessions': 1,
          },
          // Add more data as needed
        ],
      ),
    ),
  ));
}
