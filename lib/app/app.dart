import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:videoplayerdemo/app/custom/custom_progress_bar.dart';
import 'package:videoplayerdemo/app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

import 'custom/custom_controls.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Video Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;


  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  List<String> srcs = [
   // 'http://player.alicdn.com/video/aliyunmedia.mp4',
  //  "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
   // "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
    "https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
 //   "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
   /* _videoPlayerController1 =
        VideoPlayerController.asset('assets/Butterfly-209.mp4');*/
    _videoPlayerController2 =
        VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Hello',
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
            TextSpan(
              text: ' from ',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            TextSpan(
              text: 'subtitles',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            )
          ],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: 'Whats up? :)',
        // text: const TextSpan(
        //   text: 'Whats up? :)',
        //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        // ),
      ),
    ];

    bool canChangeProgress = true;
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: false,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: toggleVideo,
              iconData: Icons.live_tv_sharp,
              title: 'Toggle Video Src',
            ),
          ];
        },
        subtitle: Subtitles(subtitles),
        subtitleBuilder: (context, dynamic subtitle) => Container(
              padding: const EdgeInsets.all(10.0),
              child: subtitle is InlineSpan
                  ? RichText(
                      text: subtitle,
                    )
                  : Text(
                      subtitle.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
            ),
        draggableProgressBar: canChangeProgress,
        hideControlsTimer: const Duration(seconds: 5),
        customControls: CustomControls(
          backgroundColor: Colors.green,
          iconColor: Colors.white,
          onProgressChange: (value) {
            /*if (_videoPlayerController1.value.position.inSeconds > 5) {
              setState(() {
                canChangeProgress = false;
              });
            }else{
              setState(() {
                canChangeProgress = true;
              });
            }*/
            /*if(offset!=null) {
              Duration position = context.calculateRelativePosition(
                _videoPlayerController1.value.duration,
                offset,
              );

              print(
                  'position...$position...${position.inSeconds}');

              if(position.inSeconds>100) {
                _videoPlayerController1.seekTo(position);
              }else{
                _videoPlayerController1.seekTo(const Duration(seconds: 60));
              }
            }*/
            if(value!=null) {
              print('object.get....$value');
            //  if (value <= 180) {
                _videoPlayerController1.seekTo(Duration(seconds: value.toInt()));
              //}
            }
          },
        )
        // Try playing around with some of these other options:

        // showControls: false,
        // materialProgressColors: ChewieProgressColors(
        //   playedColor: Colors.red,
        //   handleColor: Colors.blue,
        //   backgroundColor: Colors.grey,
        //   bufferedColor: Colors.lightGreen,
        // ),
        // placeholder: Container(
        //   color: Colors.grey,
        // ),
        // autoInitialize: true,
        );
  }



  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int minutes = duration.inMinutes;
    int remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: AppTheme.dark.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController!,
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

