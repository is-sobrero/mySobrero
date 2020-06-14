import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {

  Skeleton({Key key }) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;


  @override
  void initState() {

    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.linear
      ),
    )..addListener(() {
      setState(() {});
    });
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(-1 + gradientPosition.value, -1),
              end: Alignment(1 + gradientPosition.value, 1),
              colors: [Colors.black.withAlpha(10), Colors.white.withAlpha(90), Colors.black.withAlpha(10)]
          ),
      ),
    );
  }
}