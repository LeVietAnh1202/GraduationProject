import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/model/studentModel.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:flutter_todo_app/singleChoice.dart';
import 'package:flutter_todo_app/students/studentService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class DetailStudent extends StatefulWidget {
  final String studentId; // Thêm trường studentId
  const DetailStudent({Key? key, required this.studentId});

  @override
  State<DetailStudent> createState() => _DetailStudentState();
}

class _DetailStudentState extends State<DetailStudent> {
  List<Student> students = [];
  late VideoPlayerController _controller;

  bool isVideoPlaying = false;
  bool isVideoEnded = false;
  double videoPosition = 0.0;
  double videoDuration = 0.0;

  late FlickManager flickManager;

  // List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.networkUrl(
    //     Uri.http(url_ras, '${URLVideoPath}/video_default.mp4'));
    // _controller.initialize().then((_) {
    //   setState(() {});
    // });
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
            Uri.http(url_ras, '${URLVideoPath}/video_default.mp4')));

    Provider.of<AppStateProvider>(context, listen: false)
        .setCalendarView(Calendar.week);
    // Gọi hàm fetchStudents để tải dữ liệu sinh viên
    StudentService.fetchStudents(context, (value) {});
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100, // Độ rộng cố định cho nhãn
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

  @override
  Widget build(BuildContext context) {
    Student defaultStudent = Student.fromMap({});
    students = context.watch<AppStateProvider>().appState!.students;
    Student student = students.firstWhere(
      // Map<String, dynamic> student = students.firstWhere(
      (student) {
        print(student);
        print("student['studentId']" + student.studentId);
        print("widget.studentId" + widget.studentId);
        return student.studentId == widget.studentId;
      },
      orElse: () => defaultStudent,
    );

    print('${URLNodeJSServer}/images/avatar/${student.avatar}');

    return AlertDialog(
      title: Text('Detail student'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('ID:', student.studentId),
                      _buildInfoRow('Full name:', student.studentName),
                      _buildInfoRow('Class code:', student.classCode),
                      _buildInfoRow('Gender:', student.gender),
                      _buildInfoRow(
                        'Birth date:',
                        DateFormat('dd/MM/yyyy').format(student.birthDate),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  child: Image.network(
                    '${URLNodeJSServer_RaspberryPi_Images}/avatar/${student.avatar}',
                    width: 150, // Điều chỉnh chiều rộng nếu cần
                    height: 150, // Điều chỉnh chiều cao nếu cần
                    loadingBuilder: (BuildContext context, Widget child,
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
                        '${URLNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                        width: 150, // Điều chỉnh chiều rộng nếu cần
                        height: 150, // Điều chỉnh chiều cao nếu cần
                      );
                    },
                  ),
                ),
              ],
            ),
            SingleChoice(option: SegmentButtonOption.image),
            SizedBox(height: 30),
            (Provider.of<AppStateProvider>(context, listen: false)
                        .appState
                        ?.imagesView) ==
                    ShowImage.video
                // ? flickManager != null
                ? SizedBox(
                    height: 405,
                    width: 720,
                    child: AspectRatio(
                      // aspectRatio: _controller.value.aspectRatio,
                      aspectRatio: 16 / 9,
                      child: FlickVideoPlayer(
                        flickManager: flickManager,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 400,
                    width: double.maxFinite,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 200,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(children: [
                            Image.network(
                              '${URLNodeJSServer_RaspberryPi_Images}/${(Provider.of<AppStateProvider>(context, listen: false).appState?.imagesView) == ShowImage.full ? 'full_images' : 'crop_images'}/${student.avatar.toString().substring(0, student.avatar.toString().indexOf('.'))}/${1}.jpg',
                              width: 131, // Điều chỉnh chiều rộng nếu cần
                              height: 131, // Điều chỉnh chiều cao nếu cần
                              fit: BoxFit.contain,
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
                                  '${URLNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
                                  width: 131, // Điều chỉnh chiều rộng nếu cần
                                  height: 131, // Điều chỉnh chiều cao nếu cần
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Image ' + (index + 1).toString(),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ]),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
