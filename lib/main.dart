import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayerdemo/home_page.dart';
import 'package:videoplayerdemo/recent_list.dart';
import 'package:videoplayerdemo/app/app.dart';

void main() {
  runApp(ChewieDemo());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // FijkLog.setLevel(FijkLogLevel.Debug);
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFffd54f),
        primaryColorDark: Color(0xFFffc107),
        primaryColorLight: Color(0xFFffecb3),
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFFC107)),
        dividerColor: Color(0xFFBDBDBD),
      ),
      home: SamplesScreen(),
    );
  }
}