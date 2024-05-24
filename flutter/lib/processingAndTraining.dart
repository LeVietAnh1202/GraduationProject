import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/string.dart';
import 'package:flutter_todo_app/videoStream.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:video_player/video_player.dart';

class ProcessingAndTraining extends StatefulWidget {
  String text = 'text';
  @override
  _ProcessingAndTrainingState createState() => _ProcessingAndTrainingState();
}

class _ProcessingAndTrainingState extends State<ProcessingAndTraining> {
  bool _loading = false;
  String _result = "";
  List<dynamic> messages = [];
  StreamController<String> _streamController = StreamController<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // flickManager = FlickManager(
    //     videoPlayerController: VideoPlayerController.networkUrl(
    //   Uri.parse(
    //       "http://192.168.1.3:3000/videos/default/12520088_LeVietAnh.mp4"),
    // ));
  }

  @override
  void dispose() {
    _streamController.close();
    // flickManager.dispose();
    super.dispose();
  }

  // Future<http.ByteStream> getStream(http.Request request) async {
  //   final FetchClient fetchClient = FetchClient(mode: RequestMode.cors);
  //   final FetchResponse response = await fetchClient.send(request);
  //   return response.stream;
  // }

  // void _callAPIProcess() async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   try {
  //     var response = await http.get(
  //       Uri.http('127.0.0.1:8000', 'process'),
  //       // headers: <String, String>{
  //       //   'Content-Type': 'application/json; charset=UTF-8',
  //       // },
  //       // body: jsonEncode(<String, dynamic>{
  //       //   'manu_scripts': [
  //       //     {'name': 'Your Manuscript Name'}
  //       //     // Add more manuscripts if needed
  //       //   ],
  //       //   'n_db_view': 10,
  //       // }),
  //     );

  //     // var stream = response.bodyBytes;
  //     //   var stream = await getStream(http.Request('GET', Uri.http('127.0.0.1:8000', 'process')));
  //     //   stream.transform(utf8.decoder).transform(const LineSplitter()).listen((String line) {
  //     //     print(line);
  //     //   setState(() {
  //     //     // messages.add(line);
  //     //     widget.text = line;
  //     //     _streamController.add(line); // Thêm dòng vào stream
  //     //   });
  //     // });

  //     // Stream<List<int>> byteStream = Stream.fromIterable([stream]);

  //     // byteStream
  //     //     .transform(utf8.decoder)
  //     //     .transform(const LineSplitter())
  //     //     .listen((dynamic line) {
  //     //   print("line: " + line);
  //     //   setState(() {
  //     //     // messages.add(line);
  //     //     widget.text = line.toString();
  //     //   });
  //     // });

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       // Handle your response data here
  //       setState(() {
  //         _result = jsonResponse.toString();
  //       });
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: Text('API Response'),
  //           content: Text(_result),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }

  //   setState(() {
  //     _loading = false;
  //   });
  // }

  void _callAPIProcess() async {
    setState(() {
      _loading = true;
    });

    try {
      var response = await http.get(
        Uri.http('127.0.0.1:8001', 'process'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // Handle your response data here
        setState(() {
          _result = jsonResponse.toString();
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('API Response'),
            content: Text(_result),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _loading = false;
    });
  }

  void _callAPITrainModel() async {
    setState(() {
      _loading = true;
    });

    try {
      var response = await http.get(
        Uri.http('127.0.0.1:8001', 'train_model'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // Handle your response data here
        setState(() {
          _result = jsonResponse.toString();
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('API Response'),
            content: Text(_result),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _loading = false;
    });
  }

  void _callAPICropVideo() async {
    setState(() {
      _loading = true;
    });

    try {
      var response = await http.post(
        Uri.http('192.168.1.4:8001', 'crop_video'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "video_path":
              '${URLNodeJSServer_RaspberryPi_Videos}/10120620_NguyenMinhDoanh.mp4',
        }),
      );

      // var response = await http.get(
      //   Uri.http('192.168.1.4:8001', ''),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _result = jsonResponse.toString();
          _loading = false;
        });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('API Response'),
            content:
                Text("Images_count: " + jsonResponse['image_count'].toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to crop video');
      }
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

  void _callAPIConnectCamera() async {
    setState(() {
      _loading = true;
    });

    try {
      var response = await http.get(
        Uri.http('127.0.0.1:8001', 'connect_camera'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // Handle your response data here
        setState(() {
          _result = jsonResponse.toString();
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('API Response'),
            content: Text(_result),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // ElevatedButton(
          //   onPressed: _callAPIProcess,
          //   child: Text('Call API process'),
          // ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _callAPITrainModel,
            child: Text('Call API process'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _callAPITrainModel,
            child: Text('Call API train model'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _callAPIConnectCamera,
            child: Text('Call API connect camera'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loading ? null : _callAPICropVideo,
            child: _loading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : Text('Call API crop video'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ShowVideo();
                  });
            },
            child: Text('Show video'),
          ),

          // VideoStreamWidget()

          //Container(width: 512, height: 456, child: VideoStream(title: "Video stream Python-Flutter",))
          // Container(width: 512, height: 256, child: VideoStream(title: "Video stream Python-Flutter",))
        ],
      ),

      // child: _loading
      //     // ? CircularProgressIndicator()
      //     ? Expanded(
      //         child: ListView.builder(
      //           itemCount: messages.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return ListTile(
      //               title: Text(messages[index].toString()),
      //             );
      //           },
      //         )
      //     )
      //     : ElevatedButton(
      //         onPressed: _callAPI,
      //         child: Text('Call API'),
      //       ),

      // child: Column(
      //   children: [
      //     ElevatedButton(
      //       onPressed: _callAPI,
      //       child: Text('Call API'),
      //     ),
      //     // Container(
      //     //       child: ListView.builder(
      //     //         itemCount: messages.length,
      //     //         itemBuilder: (BuildContext context, int index) {
      //     //           return ListTile(
      //     //             title: Text(messages[index].toString()),
      //     //           );
      //     //         },
      //     //       )
      //     //   ),
      //     // Text(widget.text)

      //     // Container(
      //     //   width: double.maxFinite,
      //     //   height: 400,
      //     //   child: StreamBuilder<String>(
      //     //     stream: _streamController.stream,
      //     //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      //     //       if (snapshot.connectionState == ConnectionState.waiting) {
      //     //         return CircularProgressIndicator();
      //     //       } else if (snapshot.hasError) {
      //     //         return Text('Error: ${snapshot.error}');
      //     //       } else {
      //     //         return ListView.builder(
      //     //           itemCount: snapshot.data?.length,
      //     //           itemBuilder: (BuildContext context, int index) {
      //     //             return ListTile(
      //     //               title: Text(snapshot.data![index]),
      //     //             );
      //     //           },
      //     //         );
      //     //       }
      //     //     },
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}

class ShowVideo extends StatefulWidget {
  const ShowVideo({super.key});

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late FlickManager flickManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      // Uri.parse(
      //     "http://192.168.1.3:3000/videos/default/12520088_LeVietAnh.mp4"),
      Uri.http("192.168.1.3:3000", "videos/default/12520088_LeVietAnh.mp4")
    ));
  }

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('API Response'),
      content: Container(
          width: 500,
          height: 500,
          child: FlickVideoPlayer(flickManager: flickManager)),
      actions: [
        TextButton(
          onPressed: () {
            flickManager.dispose();
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
