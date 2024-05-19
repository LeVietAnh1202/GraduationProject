import 'dart:io';

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
  Key _imageKey = UniqueKey();
  // late VideoPlayerController _controller;

  bool hasVideo = false;
  bool isVideoEnded = false;
  double videoPosition = 0.0;
  double videoDuration = 0.0;

  late Student student;
  late FlickManager flickManager;
  late VideoPlayerController _videoPlayerController;
  // List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    // flickManager = FlickManager(
    //     videoPlayerController: VideoPlayerController.networkUrl(
    //         Uri.http(url_ras, '${URLVideoPath}/video_default.mp4'))
    //       ..initialize().then((_) {
    //         setState(() {});
    //       }));

    // Provider.of<AppStateProvider>(context, listen: false)
    //     .setCalendarView(Calendar.week);
    // Gọi hàm fetchStudents để tải dữ liệu sinh viên
    // StudentService.fetchStudents(context, (value) {});

    initVideo();

    // final defaultStudent = Student.fromMap({});
    // final students = Provider.of<AppStateProvider>(context, listen: false)
    //     .appState!
    //     .students;
    // student = students.firstWhere(
    //   (student) => student.studentId == widget.studentId,
    //   orElse: () => defaultStudent,
    // );
    // print("Student: ");
    // print(student);
    // Future.delayed(Duration.zero, () async {
    //   flickManager = await getVideo(student);
    // });
  }

  @override
  void dispose() {
    flickManager.dispose();
    _videoPlayerController.dispose();
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

  // FlickManager getVideo(Student student) {
  //   try {
  //     flickManager = FlickManager(
  //         videoPlayerController: VideoPlayerController.networkUrl(
  //             Uri.http(url_ras, '${URLVideoPath}/${student.video}'))
  //           ..initialize().then((_) {
  //             // setState(() {});
  //           }));
  //     print('try');
  //   } catch (e) {
  //     print('catch');
  //     flickManager = FlickManager(
  //         videoPlayerController: VideoPlayerController.networkUrl(
  //             Uri.http(url_ras, '${URLVideoPath}/video_default.mp4'))
  //           ..initialize().then((_) {
  //             // setState(() {});
  //           }));
  //     print(flickManager);
  //   }
  //   print('fliclManager');
  //   return flickManager;
  // }

  // FlickManager getVideo(Student student) {
  //   flickManager = FlickManager(
  //     videoPlayerController: VideoPlayerController.networkUrl(
  //       Uri.http(url_ras, '${URLVideoPath}/${student.video}'),
  //     )..initialize().then(
  //         (_) {
  //           // setState(() {});
  //         },
  //       ).catchError((error) {
  //         print('Error initializing video: $error');
  //         flickManager = FlickManager(
  //           videoPlayerController: VideoPlayerController.networkUrl(
  //             Uri.http(url_ras, '${URLVideoPath}/video_default.mp4'),
  //           )..initialize().then(
  //               (_) {
  //                 // setState(() {});
  //               },
  //             ),
  //         );
  //       }),
  //   );

  //   return flickManager;
  // }

  FlickManager getVideo(Student student) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(
            Uri.http(url_ras, '${URLVideoPath}/${student.video}'));
    return FlickManager(
        videoPlayerController: videoPlayerController
          ..initialize().then((_) {
            videoPlayerController.play();
            setState(() {
              hasVideo = true;
              print(hasVideo);
            });
            print('Video initialized successfully');
          }).catchError((error) {
            // Xử lý lỗi khi không thể khởi tạo video
            print('Error initializing video: $error');
          }));
  }

  void initVideo() {
    // try {
    final defaultStudent = Student.fromMap({});
    final students = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .students;
    student = students.firstWhere(
      (student) => student.studentId == widget.studentId,
      orElse: () => defaultStudent,
    );

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.http(url_ras, '${URLVideoPath}/${student.video}'))
      // Uri.parse('http://' + url_ras + '/${URLVideoPath}/${student.video}'))
      ..initialize().then((value) {
        _videoPlayerController.play();
        // _videoPlayerController.setLooping(true);
        setState(() {});
      });
    // Future.delayed(Duration(milliseconds: 200), () {});
    flickManager = FlickManager(videoPlayerController: _videoPlayerController);
    // } catch (e) {
    //   print('catch ' + e.toString());
    // }
  }

  // Future<FlickManager> getVideo(Student student) async {
  //   try {
  //     final controller = VideoPlayerController.networkUrl(
  //       Uri.http(url_ras, '${URLVideoPath}/${student.video}'),
  //     );
  //     await controller.initialize();
  //     // Thực hiện các bước khác nếu cần thiết sau khi video được khởi tạo thành công
  //     hasVideo = true;
  //     print('Video initialized successfully');
  //     return FlickManager(videoPlayerController: controller);
  //   } catch (error) {
  //     // Xử lý lỗi khi không thể khởi tạo video
  //     print('Error initializing video: $error');
  //     throw error; // Re-throw lỗi để nó có thể được bắt ở nơi gọi
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Tìm sinh viên có studentId tương ứng trong danh sách students đã tải
    // Map<String, dynamic> defaultStudent = {
    //   'studentId': '',
    //   'studentName': '',
    //   'classCode': '',
    //   'gender': '',
    //   'birthDate': '',
    // };

    final defaultStudent = Student.fromMap({});
    final students = context.watch<AppStateProvider>().appState!.students;
    student = students.firstWhere(
      (student) => student.studentId == widget.studentId,
      orElse: () => defaultStudent,
    );

    ShowImage imagesView = Provider.of<AppStateProvider>(context, listen: false)
        .appState!
        .imagesView;
    print(imagesView);

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
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Mã sinh viên:', student.studentId),
                      _buildInfoRow('Họ tên:', student.studentName),
                      _buildInfoRow('Lớp:', student.classCode),
                      _buildInfoRow('Chuyên ngành:', student.specializationID),
                      _buildInfoRow('Giới tính:', student.gender),
                      _buildInfoRow(
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
                    child: Container(
                        child: _videoPlayerController.value.isInitialized
                            // ? AspectRatio(
                            //     aspectRatio:
                            //         _videoPlayerController.value.aspectRatio,
                            //     child: VideoPlayer(_videoPlayerController),
                            //   )
                            // : Container(),
                            ? FlickVideoPlayer(flickManager: flickManager)
                            : Container())

                    // AspectRatio(
                    //     // aspectRatio: _controller.value.aspectRatio,
                    //     aspectRatio: 16 / 9,
                    //     child:
                    //         //  (hasVideo)
                    //         //     ? Center(child: CircularProgressIndicator())
                    //         //     :
                    //         // FlickVideoPlayer(flickManager: getVideo(student))

                    //         //     FutureBuilder(
                    //         //   future: _initializeVideoPlayerFuture,
                    //         //   builder: (context, snapshot) {
                    //         //     if (snapshot.connectionState ==
                    //         //         ConnectionState.done) {
                    //         //       return AspectRatio(
                    //         //         aspectRatio:
                    //         //             _videoPlayerController.value.aspectRatio,
                    //         //         child: VideoPlayer(_videoPlayerController),
                    //         //       );
                    //         //     } else {
                    //         //       return Center(child: CircularProgressIndicator());
                    //         //     }
                    //         //   },
                    //         // )

                    //     //     FutureBuilder<VideoPlayerController>(
                    //     //   future: VideoPlayerController.networkUrl(
                    //     //           Uri.http(url_ras, '${URLVideoPath}/${student.video}'))
                    //     //       ..initialize().then((value) => null),
                    //     //   builder: (context, snapshot) {
                    //     //     if (snapshot.hasData) {
                    //     //       return VideoPlayer(snapshot.data!);
                    //     //     } else if (snapshot.hasError) {
                    //     //       return Text('Lỗi: ${snapshot.error}');
                    //     //     } else {
                    //     //       return CircularProgressIndicator();
                    //     //     }
                    //     //   },
                    //     // )

                    //     // child: FlickVideoPlayer(
                    //     //   flickManager: FlickManager(
                    //     //     videoPlayerController:
                    //     //         VideoPlayerController.networkUrl(
                    //     //       Uri.http(
                    //     //           url_ras, '${URLVideoPath}/${student.video}'),
                    //     //     )..initialize().then(
                    //     //             (_) {},
                    //     //             onError: (error) {
                    //     //               // Xử lý lỗi khi không thể khởi tạo video từ URL
                    //     //               print('Error initializing video: $error');
                    //     //               // Trả về video mặc định khi không lấy được video từ URL
                    //     //               VideoPlayerController.networkUrl(Uri.http(
                    //     //                   url_ras,
                    //     //                   '${URLVideoPath}/video_default.mp4'));
                    //     //             },
                    //     //           ),
                    //     //   ),
                    //     // ),

                    //     //               child: FlickVideoPlayer(
                    //     //                 flickManager: FlickManager(
                    //     // videoPlayerController: VideoPlayerController.networkUrl(
                    //     //     Uri.http(url_ras, '${URLVideoPath}/video_default.mp4'))),
                    //     //               ),
                    //     ),
                    )
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
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: imagesView == ShowImage.full
                                      ? student.NoFullImage
                                      : student.NoCropImage,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImagesView(
                                          student: student,
                                          index: index,
                                          imageKey: _imageKey),
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
        width: 131,
        height: 131,
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
      '${URLNodeJSServer_Python_Images}/${Provider.of<AppStateProvider>(context, listen: false).appState?.imagesView == ShowImage.full ? 'full_images' : 'crop_images'}/${widget.student.avatar.toString().substring(0, widget.student.avatar.toString().indexOf('.'))}/${widget.index + 1}.jpg',
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
