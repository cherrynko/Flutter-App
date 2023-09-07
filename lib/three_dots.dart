import 'package:flutter/material.dart';
import 'dart:async';

class FlickeringDotsAnimation extends StatefulWidget {
  @override
  _FlickeringDotsAnimationState createState() => _FlickeringDotsAnimationState();
}

class _FlickeringDotsAnimationState extends State<FlickeringDotsAnimation> {
  late Timer _timer;
  bool showDot1 = true;
  bool showDot2 = true;
  bool showDot3 = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        showDot1 = !showDot1;
        showDot2 = !showDot2;
        showDot3 = !showDot3;
      });
    });

    // Stop the timer after 5 seconds (5000 milliseconds)
    Timer(Duration(seconds: 5), () {
      _timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: showDot1 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Dot(),
        ),
        SizedBox(width: 4),
        AnimatedOpacity(
          opacity: showDot2 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Dot(),
        ),
        SizedBox(width: 4),
        AnimatedOpacity(
          opacity: showDot3 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Dot(),
        ),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}