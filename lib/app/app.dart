import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:simple_pip_mode/actions/pip_action.dart';
import 'package:simple_pip_mode/actions/pip_actions_layout.dart';
import 'package:simple_pip_mode/pip_widget.dart'; // To build pip mode dependent layouts
import 'package:simple_pip_mode/simple_pip.dart'; // To enter pip mode and receive callbacks
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';
import 'package:videoplayerdemo/app/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late SimplePip pip;
  bool pipAvailable = false;
  bool autoPipAvailable = false;
  bool autoPipSwitch = false;
  bool isInPIPMode = false;
  PipActionsLayout pipActionsLayout = PipActionsLayout.none;
  List<Subtitle> subtitles = [];
  bool canChangeProgress = true;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    pip = SimplePip();
    requestPipAvailability();
  }

  /// Checks if system supports PIP mode
  Future<void> requestPipAvailability() async {
    var isAvailable = await SimplePip.isPipAvailable;
    var isAutoPipAvailable = await SimplePip.isAutoPipAvailable;
    setState(() {
      pipAvailable = isAvailable;
      autoPipAvailable = isAutoPipAvailable;
    });
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

    subtitles = [
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
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    Fluttertoast.showToast(
        msg: "This is additional action",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    /*await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();*/
  }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int minutes = duration.inMinutes;
    int remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  List<DropdownMenuItem<PipActionsLayout>> layoutList() {
    return PipActionsLayout.values
        .map<DropdownMenuItem<PipActionsLayout>>(
          (PipActionsLayout value) => DropdownMenuItem<PipActionsLayout>(
        child: Text(value.name),
        value: value,
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: widget.title,
        theme: AppTheme.dark.copyWith(
          platform: _platform ?? Theme.of(context).platform,
        ),
        home: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            pip.setPipActionsLayout(PipActionsLayout.media_only_pause);
            pip.setIsPlaying(_chewieController!.isPlaying);
            pip.enterPipMode(
              aspectRatio: [16, 9],
            );
          },
          child: PipWidget(
            builder: (context) {
              isInPIPMode = false;
              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: _videoPlayerController1.value.isInitialized
                            ? videoWidget()
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
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            },
            pipLayout: pipActionsLayout,
            onPipAction: (action) {
              switch (action) {
                case PipAction.play:
                    _chewieController!.play();
                  pip.setIsPlaying(true);
                  break;
                case PipAction.pause:
                    _chewieController!.pause();
                  pip.setIsPlaying(false);
                  break;
                case PipAction.previous:
                  break;
                case PipAction.next:
                  break;
                case PipAction.live:
                  break;
              }
            },
            pipBuilder: (context) {
              isInPIPMode = true;
              return videoWidget();
            },
          ),
        ));
  }

  Widget videoWidget() {
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: _chewieController!=null?_chewieController!.isPlaying:true,
        looping: false,
        showControls: !isInPIPMode,
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
            if (value != null) {
              print('object.get....$value');
              //if (value <= 180) {
              _videoPlayerController1
                  .seekTo(Duration(seconds: value.toInt()));
              //}
            }
          },
        )
    );
    return Chewie(
      controller: _chewieController!,
    );
  }
}
