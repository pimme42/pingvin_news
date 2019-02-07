import 'package:pingvin_news/Misc/Constants.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class LoadIndicator extends StatefulWidget {
  @override
  State<LoadIndicator> createState() => _LoadIndicatorState();
}

class _LoadIndicatorState extends State<LoadIndicator>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    _animation = new Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        this.setState(() {});
      })
      /* Så att animationen fortsätter, och inte stannar efter en rotation */
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.forward(from: 0.0);
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      origin: Offset(
          IconTheme.of(context).size / 2, IconTheme.of(context).size / 2),
      transform: Matrix4.skewX(-0.2)..rotateY(2 * _animation.value * pi),
      child: ImageIcon(
        ExactAssetImage(Constants.logoPathEllipse),
      ),
    );
  }
}
