import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/attendance/utilities.dart';
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
import 'package:http/http.dart' as http;

class DetailStudent extends StatefulWidget {
  final String studentId; // Thêm trường studentId
  const DetailStudent({Key? key, required this.studentId});

  @override
  State<DetailStudent> createState() => _DetailStudentState();
}

class _DetailStudentState extends State<DetailStudent> {
  List<Student> students = [];

  String _result = "";
  bool _loading = false;
  bool hasVideo = true;
  bool isVideoEnded = false;
  double videoPosition = 0.0;
  double videoDuration = 0.0;

  ShowImage option = ShowImage.video;

  late Student student;
  late FlickManager flickManager;
  late VideoPlayerController _videoPlayerController;
  Key _imageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    StudentService.fetchStudents(context, (value) {});

    initStudent();

    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
            Uri.http(url_ras, "videos/default/${student.video}")));
  }

  void initStudent() {
    final defaultStudent = Student.fromMap({});
    final students = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .students;
    setState(() {
      student = students.firstWhere(
        (student) => student.studentId == widget.studentId,
        orElse: () => defaultStudent,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    flickManager.dispose();
    super.dispose();
  }

  Future<FlickManager> getVideo(Student student) async {
    try {
      VideoPlayerController videoPlayerController =
          VideoPlayerController.networkUrl(
              Uri.http(url_ras, '${URLVideoPath}/${student.video}'));
      await videoPlayerController.initialize();
      return FlickManager(videoPlayerController: videoPlayerController);
    } catch (e) {
      print('Error initializing video player: $e');
      rethrow; // Re-throw the error to handle it in the FutureBuilder
    }
  }

  // Function to call your API
  void _callAPIHandleVideo() async {
    setState(() {
      _loading = true;
    });
    // final socket = Provider.of<AppStateProvider>(context, listen: false).appState!.socket;
    int dotIndex = student.video.lastIndexOf('.');
    print(student.video);
    var fileName = '';
    if (dotIndex != -1) {
      fileName = student.video.substring(0, dotIndex);
    }
    // socket.emit('crop_video', {
    //   "video_path": "${URLNodeJSServer_RaspberryPi_Videos}/${student.video}",
    //   "images_path": "./train_img/${fileName}"
    // });

    // socket.on('updateNoImage', (data) {
    //   setState(() {
    //     _loading = false;
    //   });
    // });

    // setState(() {
    //   _loading = true;
    // });
    print('_callAPIHandleVideo');
    try {
      int dotIndex = student.video.lastIndexOf('.');
      var fileName = '';
      if (dotIndex != -1) {
        fileName = student.video.substring(0, dotIndex);
      }
      var response = await http.post(
        Uri.http(url_python, 'crop_video'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "video_path":
              '${URLNodeJSServer_RaspberryPi_Videos}/${student.video}',
          "images_path": "./train_img/${fileName}"
        }),
      );
      var jsonResponse;
      if (response.statusCode == 200) {
        jsonResponse = jsonDecode(response.body);
        setState(() {
          _result = jsonResponse.toString();
          _loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xử lý video của sinh viên thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        jsonResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Xử lý video của sinh viên thất bại - ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('Failed to handle video');
      }

      // showDialog(
      //   context: context,
      //   builder: (_) => AlertDialog(
      //     title: Text('API Response handle'),
      //     content: Text(
      //         "Images_count:  + ${jsonResponse['status'] ? jsonResponse['total_images_processed'] : 'false'}"),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
    } catch (error) {
      setState(() {
        _loading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      print(error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStudent = Student.fromMap({});
    final students = context.watch<AppStateProvider>().appState!.students;
    final student = students.firstWhere(
      (student) => student.studentId == widget.studentId,
      orElse: () => defaultStudent,
    );

    ShowImage imagesView = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .imagesView;

    return AlertDialog(
      title: Text('Chi tiết sinh viên'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 240,
                  width: 390,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utilities.buildInfoRow(
                          'Mã sinh viên:', student.studentId),
                      Utilities.buildInfoRow('Họ tên:', student.studentName),
                      Utilities.buildInfoRow('Lớp:', student.classCode),
                      Utilities.buildInfoRow(
                          'Chuyên ngành:', student.specializationName),
                      Utilities.buildInfoRow('Giới tính:', student.gender),
                      Utilities.buildInfoRow(
                        'Ngày sinh:',
                        DateFormat('dd/MM/yyyy').format(student.birthDate),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  child: Image.network(
                    '${URLNodeJSServer_RaspberryPi_Images}/avatar/${student.avatar}',
                    width: 150,
                    height: 150,
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
                        width: 150,
                        height: 150,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // SingleChoice(
            //   option: SegmentButtonOption.image,
            //   changeImageOption: (selectedOption) {
            //     setState(() {
            //       option = selectedOption;
            //     });
            //   },
            // ),\
            Row(
              mainAxisAlignment: (imagesView == ShowImage.video)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                SingleChoice(
                  option: SegmentButtonOption.image,
                  changeImageOption: (selectedOption) {
                    setState(() {
                      // option = selectedOption;
                    });
                  },
                ),
                if (imagesView == ShowImage.video)
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _callAPIHandleVideo,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors
                                      .green; // Color when the button is pressed
                                }
                                return Colors.blue; // Default color
                              },
                            ),
                          ),
                          child: Text('Xử lý video'),
                        ),
              ],
            ),
            SizedBox(height: 30),
            (Provider.of<AppStateProvider>(context, listen: false)
                        .appState
                        ?.imagesView) ==
                    ShowImage.video
                ? SizedBox(
                    height: 405,
                    width: 720,
                    child: Container(
                      width: 400,
                      height: 400,
                      child: FlickVideoPlayer(
                        flickManager: flickManager,
                        flickVideoWithControls: FlickVideoWithControls(
                          videoFit: BoxFit
                              .contain, // Đây là nơi bạn định nghĩa BoxFit.cover
                          controls: FlickPortraitControls(),
                        ),
                      ),
                    ))
                // : SizedBox(
                //     child: Container(
                //     child: Text("Video"),
                //   )),
                : SizedBox(
                    height: 400,
                    width: double.maxFinite,
                    child: Center(
                      child: (imagesView == ShowImage.full &&
                              student.NoFullImage == 0)
                          ? Text("Không có ảnh chưa tiền xử lý.")
                          : (imagesView == ShowImage.crop &&
                                  student.NoCropImage == 0)
                              ? Text("Không có ảnh đã tiền xử lý.")
                              : GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 10,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 2.0,
                                  ),
                                  itemCount: imagesView == ShowImage.full
                                      ? student.NoFullImage
                                      : student.NoCropImage,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      // padding: EdgeInsets.all(8.0),
                                      child: ImagesView(
                                          student: student,
                                          index: index,
                                          imageKey: _imageKey),
                                      // child: Text('hình'),
                                    );
                                  },
                                ),
                    ),
                  ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Provider.of<AppStateProvider>(context, listen: false)
                .setImagesView(ShowImage.video);
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class ImagesView extends StatefulWidget {
  final Student student;
  final int index;
  final Key imageKey;
  const ImagesView(
      {super.key,
      required this.student,
      required this.index,
      required this.imageKey});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  Widget getImage(AppStateProvider appStateProvider, Key _imageKey,
      NetworkImage imageProvider) {
    try {
      return Image(
        // Sử dụng giá trị mới của imagesView từ appState
        image: imageProvider,
        key: _imageKey,
        width: 160,
        height: 150,
        fit: BoxFit.contain,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return CircularProgressIndicator();
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.network(
            '${URLNodeJSServer_RaspberryPi_Images}/avatar/avatar.jpg',
            width: 131,
            height: 131,
          );
        },
      );
    } catch (e) {
      // Xử lý ngoại lệ ở đây, ví dụ: in ra thông báo lỗi và trả về một widget khác
      print('Error loading image: $e');
      return Placeholder(); // Hoặc bạn có thể trả về một widget khác để hiển thị thông báo lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    // Xóa cache của hình ảnh cũ
    final imageProvider = NetworkImage(
      // '${URLNodeJSServer_Python_Images}/${Provider.of<AppStateProvider>(context, listen: false).appState?.imagesView == ShowImage.full ? 'full_images' : 'crop_images'}/${widget.student.avatar.toString().substring(0, widget.student.avatar.toString().indexOf('.'))}/${widget.index + 1}.jpg',
      '${URLPythonServer}/${Provider.of<AppStateProvider>(context, listen: false).appState?.imagesView == ShowImage.full ? 'train_img' : 'aligned_img'}/${widget.student.avatar.toString().substring(0, widget.student.avatar.toString().indexOf('.'))}/${widget.index + 1}.jpg',
    );
    imageProvider.evict().then((bool success) {
      if (success) {
        print('Image cache cleared.');
      } else {
        print('Failed to clear image cache.');
      }
    });

    return Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
      return Column(
        children: [
          getImage(appStateProvider, widget.imageKey, imageProvider),
          Text(
            'Image ' + (widget.index + 1).toString(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 10),
        ],
      );
    });
  }
}
