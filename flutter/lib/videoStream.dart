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


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoStreamWidget extends StatefulWidget {
  @override
  _VideoStreamWidgetState createState() => _VideoStreamWidgetState();
}

class _VideoStreamWidgetState extends State<VideoStreamWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      'rtsp://192.168.1.162:1202/h264_ulaw.sdp',
      // 'http://192.168.1.162:1202',
    );
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Stream'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
