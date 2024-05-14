// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:http/http.dart' as http;



// class VideoStreamWidget extends HookWidget {
//   @override
//   Future<Widget> build(BuildContext context) async {
//     // final videoController = useVideoPlayerController();
//     // final videoPlayerControllerFuture = useFuture(videoController.initialize());
//     late VideoPlayerController videoPlayerController;
//     videoPlayerController =
//           VideoPlayerController.network('http://192.168.1.162:1202')
//           // VideoPlayerController.network('http://127.0.0.1:8000/video_feed')
//             ..initialize().then((_) {
//               videoPlayerController.play();
//             });

//     // useEffect(() {
//     //   late VideoPlayerController videoPlayerController;

//     //   videoPlayerController =
//     //       VideoPlayerController.network('http://127.0.0.1:8000/video_feed')
//     //         ..initialize().then((_) {
//     //           videoPlayerController.play();
//     //         });

//     //   return () {
//     //     videoPlayerController.dispose();
//     //   };
//     // }, []);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Stream'),
//       ),
//       body: Center(
//         child: videoPlayerController.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: videoPlayerController.value.aspectRatio,
//                 child: VideoPlayer(videoPlayerController),
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }

//   VideoPlayerController useVideoPlayerController() {
//     return useState(VideoPlayerController.network('http://127.0.0.1:8000/video_feed')).value;
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoStreamWidget extends StatefulWidget {
//   @override
//   _VideoStreamWidgetState createState() => _VideoStreamWidgetState();
// }

// class _VideoStreamWidgetState extends State<VideoStreamWidget> {
//   late VideoPlayerController _videoPlayerController;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(
//       'rtsp://192.168.1.162:1202/h264_ulaw.sdp',
//       // 'http://192.168.1.162:1202',
//     );
//     _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
//       _videoPlayerController.play();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Stream'),
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: _initializeVideoPlayerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return AspectRatio(
//                 aspectRatio: _videoPlayerController.value.aspectRatio,
//                 child: VideoPlayer(_videoPlayerController),
//               );
//             } else {
//               return CircularProgressIndicator();
//             }
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoStream extends StatefulWidget {
  VideoStream({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _VideoStreamState createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  int frameCounter = 0;
  int lastTime = DateTime.now().millisecondsSinceEpoch;
  int fps = 0;

  final fpsValueNotifier = ValueNotifier(0);

  final pollingRate = 10; // time between requests in ms

  final url = 'http://192.168.1.6:8001/video_frame';

  bool _timeDifferenceBiggerThanSecond() {
    return DateTime.now().millisecondsSinceEpoch - lastTime > 1000;
  }

  Future<Image> _fetchVideoFrame() async {
    final response = await http.get(Uri.http('127.0.0.1:8001', 'video_frame'));

    if (_timeDifferenceBiggerThanSecond()) {
      fpsValueNotifier.value = frameCounter;
      lastTime = DateTime.now().millisecondsSinceEpoch;
      frameCounter = 0;
    } else {
      frameCounter++;
    }
    // print('response.bodyBytes: ');
    // print(response.bodyBytes);
    return Image.memory(
      response.bodyBytes,
      gaplessPlayback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder(
                valueListenable: fpsValueNotifier,
                builder: (context, value, child) {
                  return Text('FPS $value');
                }),
            StreamBuilder<Image>(
              stream: getVideoFrame(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<Image> getVideoFrame() => Stream.periodic(Duration(milliseconds: pollingRate))
      .asyncMap((_) => _fetchVideoFrame());
}
