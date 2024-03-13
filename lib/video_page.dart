import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';
// import 'custom_ui.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  VideoScreen({required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  int time = 0;
  bool isPlaying = false;
  bool isResumed = false;
  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    player.setVolume(0);
    startPlay();
  }

  void startPlay() async {
    await player.setOption(FijkOption.playerCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
      print("setDataSource error: $e");
    });

    player.addListener(() {

      if (player.state != FijkState.idle && !isResumed ) {
        player.seekTo(30000);
      }
      setState(() {
        isPlaying = player.state == FijkState.started;
        if(player.state == FijkState.paused){
          isResumed = true;
        }
      });
    });

    player.onCurrentPosUpdate.listen((duration) async {
      time = duration.inSeconds;
      if (time == 60) {
        await player.pause();
      }
      setState(() {});
    });


  }

  void _onProgressBarTap(TapUpDetails details, BoxConstraints constraints) {
    // Calculate the tap position relative to the progress bar width
    double tapPercentage = details.globalPosition.dx / constraints.maxWidth;

    // Calculate the seek position based on the tap percentage
    var seekPosition = player.value.duration.inMilliseconds * tapPercentage;

    // Seek to the calculated position
    player.seekTo(seekPosition.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FijkAppBar.defaultSetting(title: "Video"),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: GestureDetector(
              onTapUp: (details) => _onProgressBarTap(
                  details, const BoxConstraints.tightFor(height: 200)),
              child: FijkView(
                player: player,
                panelBuilder: fijkPanel2Builder(
                  snapShot: true,
                ),
                fsFit: FijkFit.fill,
                // panelBuilder: simplestUI,
                // panelBuilder: (FijkPlayer player, BuildContext context,
                //     Size viewSize, Rect texturePos) {
                //   return CustomFijkPanel(
                //       player: player,
                //       buildContext: context,
                //       viewSize: viewSize,
                //       texturePos: texturePos);
                // },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    final currentPosition = player.currentPos.inMilliseconds;
                    player.seekTo(currentPosition - 10000);
                  },
                  icon: const Icon(CupertinoIcons.arrow_left_circle_fill)),
              IconButton(
                  onPressed: () {
                   if(isPlaying) {
                     player.pause();
                   }else{
                     player.start();
                   }
                  },
                  icon:  Icon(isPlaying?CupertinoIcons.pause_fill:CupertinoIcons.play_arrow_solid)),
              IconButton(
                  onPressed: () {
                    final currentPosition = player.currentPos.inMilliseconds;
                    player.seekTo(currentPosition + 10000);
                  },
                  icon: const Icon(CupertinoIcons.arrow_right_circle_fill)),
            ],
          ),
          Text('Time in seconds: ${formatDuration(time)}\n Player State: ${player.state}'),
        ],
      ),
    );
  }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int minutes = duration.inMinutes;
    int remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
