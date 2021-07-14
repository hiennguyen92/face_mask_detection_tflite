import 'dart:async';

import 'package:face_mask_detection_tflite/services/navigation_service.dart';
import 'package:face_mask_detection_tflite/ui/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenStare();
  }
}

class _SplashScreenStare extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            Color(0xFFFC5C7D),
            Color(0xFF6A82FB),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 90.0),
      child: Icon(Icons.image),
    );
  }
}
