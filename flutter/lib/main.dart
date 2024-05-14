import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Image base64ToImage(String base64String) {
  return Image.memory(
    base64Decode(base64String),
    gaplessPlayback: true,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int frameCounter = 0;
  int lastTime = DateTime.now().millisecondsSinceEpoch;
  int fps = 0;

  final fpsValueNotifier = ValueNotifier(0);

  final pollingRate = 10; // time between requests in ms

  final url = 'http://127.0.0.1:8001/video_frame';

  bool _timeDifferenceBiggerThanSecond() {
    return DateTime.now().millisecondsSinceEpoch - lastTime > 1000;
  }

  Future<Image> _fetchVideoFrame() async {
    final response = await http.get(Uri.parse(url));

    if (_timeDifferenceBiggerThanSecond()) {
      fpsValueNotifier.value = frameCounter;
      lastTime = DateTime.now().millisecondsSinceEpoch;
      frameCounter = 0;
    } else {
      frameCounter++;
    }
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

  Stream<Image> getVideoFrame() =>
      Stream.periodic(Duration(milliseconds: pollingRate))
          .asyncMap((_) => _fetchVideoFrame());
}
