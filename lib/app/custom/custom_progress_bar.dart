import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoProgressBar extends StatelessWidget {
  CustomVideoProgressBar(
    this.controller, {
    ChewieProgressColors? colors,
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    Key? key,
  })  : colors = colors ?? ChewieProgressColors(),
        super(key: key);

  final VideoPlayerController controller;
  final ChewieProgressColors colors;
  final Function()? onDragStart;
  final Function(double? details)? onDragEnd;
  final Function()? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return VideoProgressBar(
      controller,
      barHeight: 5,
      handleHeight: 6,
      drawShadow: true,
      colors: colors,
      onDragEnd: onDragEnd,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
    );
  }
}

class VideoProgressBar extends StatefulWidget {
  VideoProgressBar(
    this.controller, {
    ChewieProgressColors? colors,
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    Key? key,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
  })  : colors = colors ?? ChewieProgressColors(),
        super(key: key);

  final VideoPlayerController controller;
  final ChewieProgressColors colors;
  final Function()? onDragStart;
  final Function(double? details)? onDragEnd;
  final Function()? onDragUpdate;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;

  @override
  // ignore: library_private_types_in_public_api
  _VideoProgressBarState createState() {
    return _VideoProgressBarState();
  }
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  void listener() {
    if (!mounted) return;
    setState(() {
      totalDuration = controller.value.duration.inSeconds;
      duration = controller.value.position.inSeconds;
      currentProgress = duration / totalDuration;
      _sliderValue =
          currentProgress * controller.value.position.inSeconds.toDouble();

      print(
          'current value $_sliderValue max value ${controller.value.duration.inSeconds.toDouble()}');
      for (final DurationRange range in controller.value.buffered) {
        final int end = range.end.inSeconds;
        if (end > buffered) {
          buffered = end;
        }
      }
    });
  }

  bool _controllerWasPlaying = false;

  Offset? _latestDraggableOffset;

  VideoPlayerController get controller => widget.controller;
  int duration = 0;
  int buffered = 0;
  int totalDuration = 0;
  double currentProgress = 0;
  double _sliderValue = 0.5;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  void _seekToRelativePosition(Offset globalPosition) {
    var position = context.calculateRelativePosition(
      controller.value.duration,
      globalPosition,
    );
    print('object  position......${position.inSeconds}');
    if (position.inSeconds <= 680) {
      controller.seekTo(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);
    final child = Center(
      child: StaticProgressBar(
        value: controller.value,
        colors: widget.colors,
        barHeight: widget.barHeight,
        handleHeight: widget.handleHeight,
        drawShadow: widget.drawShadow,
        latestDraggableOffset: _latestDraggableOffset,
      ),
    );

    /* final sliderChild=Stack(
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: SizedBox(
                height: 12,
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 5,
                      thumbShape: SliderComponentShape.noThumb,
                      thumbColor: Colors.transparent,
                      trackShape: const RectangularSliderTrackShape(),
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0),
                    ),
                    child: Slider(
                      activeColor: Colors.white54,
                      inactiveColor: Colors.white24,
                      value: buffered.toDouble(),
                      min: 0,
                      max: controller.value.duration.inSeconds
                          .toDouble(),
                      onChanged: (value) {},
                    )))),
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: SizedBox(
                height: 12,
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 5,
                     // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5,disabledThumbRadius: 5),
                       thumbShape: SliderComponentShape.noThumb,
                      thumbColor: Colors.white,
                      trackShape: const RectangularSliderTrackShape(),
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0),
                    ),
                    child: Slider(
                      inactiveColor: Colors.transparent,
                      activeColor: Colors.white,
                      value: currentProgress *
                          controller.value.position.inSeconds
                              .toDouble(),
                      max: controller.value.duration.inSeconds
                          .toDouble(),
                      onChanged: (value) {
                        print('changed progress....$value');
                          controller.seekTo(Duration(seconds: value.toInt()));
                      },
                    )))),
      ],
    );*/
    final sliderChild = Stack(
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: SizedBox(
                height: 6,
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      thumbShape: SliderComponentShape.noThumb,
                      thumbColor: Colors.transparent,
                      trackShape: const RectangularSliderTrackShape(),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 0),
                    ),
                    child: Slider(
                      activeColor: Colors.white54,
                      inactiveColor: Colors.white24,
                      value: buffered.toDouble(),
                      min: 0,
                      max: controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {},
                    )))),
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: SizedBox(
                height: 6,
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      //  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5,disabledThumbRadius: 5),
                      thumbShape: SliderComponentShape.noThumb,
                      thumbColor: Colors.white,
                      trackShape: const RectangularSliderTrackShape(),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 0),
                    ),
                    child: Slider(
                      inactiveColor: Colors.transparent,
                      activeColor: Colors.white,
                      value: currentProgress *
                          controller.value.position.inSeconds.toDouble(),
                      min: 0,
                      max: controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        print('object.progress...$value');
                        widget.onDragEnd!(value)?.call();

                        /*if(value<=60) {
                          controller.seekTo(Duration(seconds: value.toInt()));
                        }*/
                      },
                    )))),
      ],
    );

    return chewieController.draggableProgressBar
        ? GestureDetector(
            onHorizontalDragStart: (DragStartDetails details) {
              if (!controller.value.isInitialized) {
                return;
              }
              _controllerWasPlaying = controller.value.isPlaying;
              if (_controllerWasPlaying) {
                controller.pause();
              }

              widget.onDragStart?.call();
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              if (!controller.value.isInitialized) {
                return;
              }
              _latestDraggableOffset = details.globalPosition;
              listener();
              widget.onDragUpdate?.call();
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              if (_controllerWasPlaying) {
                controller.play();
              }

              if (_latestDraggableOffset != null) {
                _seekToRelativePosition(_latestDraggableOffset!);
                // widget.onDragEnd!(_latestDraggableOffset)?.call();
                _latestDraggableOffset = null;
              } else {
                //widget.onDragEnd!(_latestDraggableOffset)?.call();
              }
            },
            onTapDown: (TapDownDetails details) {
              if (!controller.value.isInitialized) {
                return;
              }
              // widget.onDragEnd!(details.globalPosition)?.call();
              // _seekToRelativePosition(details.globalPosition);
            },
            child: child,
          )
        : child;
  }
}

class StaticProgressBar extends StatelessWidget {
  const StaticProgressBar({
    Key? key,
    required this.value,
    required this.colors,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
    this.latestDraggableOffset,
  }) : super(key: key);

  final Offset? latestDraggableOffset;
  final VideoPlayerValue value;
  final ChewieProgressColors colors;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: CustomPaint(
        painter: _ProgressBarPainter(
          value: value,
          draggableValue: latestDraggableOffset != null
              ? context.calculateRelativePosition(
                  value.duration,
                  latestDraggableOffset!,
                )
              : null,
          colors: colors,
          barHeight: barHeight,
          handleHeight: handleHeight,
          drawShadow: drawShadow,
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter({
    required this.value,
    required this.colors,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
    required this.draggableValue,
  });

  VideoPlayerValue value;
  ChewieProgressColors colors;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;

  /// The value of the draggable progress bar.
  /// If null, the progress bar is not being dragged.
  final Duration? draggableValue;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseOffset = size.height / 2 - barHeight / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(size.width, baseOffset + barHeight),
        ),
        const Radius.circular(4.0),
      ),
      colors.backgroundPaint,
    );
    if (!value.isInitialized) {
      return;
    }
    final double playedPartPercent = (draggableValue != null
            ? draggableValue!.inMilliseconds
            : value.position.inMilliseconds) /
        value.duration.inMilliseconds;
    final double playedPart =
        playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * size.width;
      final double end = range.endFraction(value.duration) * size.width;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, baseOffset),
            Offset(end, baseOffset + barHeight),
          ),
          const Radius.circular(4.0),
        ),
        colors.bufferedPaint,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(playedPart, baseOffset + barHeight),
        ),
        const Radius.circular(4.0),
      ),
      colors.playedPaint,
    );

    if (drawShadow) {
      final Path shadowPath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(playedPart, baseOffset + barHeight / 2),
            radius: handleHeight,
          ),
        );

      canvas.drawShadow(shadowPath, Colors.black, 0.2, false);
    }

    canvas.drawCircle(
      Offset(playedPart, baseOffset + barHeight / 2),
      handleHeight,
      colors.handlePaint,
    );
  }
}

extension RelativePositionExtensions on BuildContext {
  Duration calculateRelativePosition(
    Duration videoDuration,
    Offset globalPosition,
  ) {
    final box = findRenderObject()! as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = (tapPos.dx / box.size.width).clamp(0, 1);
    final Duration position = videoDuration * relative;
    return position;
  }
}
