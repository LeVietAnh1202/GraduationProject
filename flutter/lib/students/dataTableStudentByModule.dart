import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DataTableStudentByModule extends StatefulWidget {
  final String moduleID;
  // final int scheduleTermsLength;
  DataTableStudentByModule(
      {Key? key, required this.moduleID, 
      // required this.scheduleTermsLength
      });

  @override
  State<DataTableStudentByModule> createState() =>
      _DataTableStudentByModuleState();
}

class _DataTableStudentByModuleState extends State<DataTableStudentByModule> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchStudentByModuleID(); // Gọi hàm setAppState sau khi initState hoàn thành
    });
  }

  Future<void> fetchStudentByModuleID() async {
    final students = await StudentService.fetchStudentByModuleID(
        context, (value) => {}, widget.moduleID);
    Provider.of<AppStateProvider>(context, listen: false)
        .setTableLength(students.length);
  }

  @override
  Widget build(BuildContext context) {
    // fetchStudentByModuleID();
    final appState = context.watch<AppStateProvider>().appState!;
    final currentPage = appState.currentPage;
    final rowsPerPage = appState.rowsPerPage;
    final students = appState.students;
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    // double widthDataTable = screenWidth - sideBarWidth - 40;
    // print('widget.scheduleAdminTermsLength: ' +
    //     widget.scheduleTermsLength.toString());
    // double heightDataTable = screenHeight -
    //     appBarHeight -
    //     2 * bodyContentPadding -
    //     breadcrumbHeight -
    //     3 * sizeBoxHeight -
    //     selectHeight -
    //     dataRowHeight * widget.scheduleTermsLength -
    //     82;

    // Calculate the start and end index of the current page
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    // Get the student list for the current page
    // List<Map<String, dynamic>> currentPageStudents =
    List<Student> currentPageStudents = students.sublist(
        startIndex, endIndex > students.length ? students.length : endIndex);

    // double iconSize = 20;
    int numberOfPages = Provider.of<AppStateProvider>(context, listen: false)
        .getNumberOfPages();

    return Container(
      // width: widthDataTable,
      // height: heightDataTable,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Ảnh',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Mã sinh viên',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Họ tên',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Lớp',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Giới tính',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Ngày sinh',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Add other columns as needed
                ],
                rows: currentPageStudents.asMap().entries.map((entry) {
                  final student = entry.value;

                  return DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: ClipOval(
                            child: Image.network(
                              '${URLNodeJSServer_RaspberryPi_Images}/avatar/${student.avatar}',
                              width: 45, // Điều chỉnh chiều rộng nếu cần
                              height: 45, // Điều chỉnh chiều cao nếu cần
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Image.network(
                                  '${URLNodeJSServer}/images/avatar/avatar.jpg',
                                  width: 150, // Điều chỉnh chiều rộng nếu cần
                                  height: 150, // Điều chỉnh chiều cao nếu cần
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      DataCell(Center(child: Text(student.studentId))),
                      DataCell(Text(
                        student.studentName,
                        textAlign: TextAlign.left,
                      )),
                      DataCell(Text(
                        student.classCode,
                        textAlign: TextAlign.left,
                      )),
                      DataCell(Center(child: Text(student.gender))),
                      DataCell(Center(
                        child: Text(
                            DateFormat('dd/MM/yyyy').format(student.birthDate)),
                      )),
                      // Add other cells as needed
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
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
