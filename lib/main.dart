import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homepage.dart';
import 'package:animated_splash/animated_splash.dart';
import 'dart:async';

import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InsideApp(),
  ));
}


class InsideApp extends StatefulWidget {
  @override
  _InsideAppState createState() => _InsideAppState();
}


class _InsideAppState extends State<InsideApp>{

  @override
  Widget build(BuildContext context) {
    // Lock vertical screen orientation
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Homepage();
  }
}

