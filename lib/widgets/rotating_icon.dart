import 'package:flutter/material.dart';

class RotatingIcon extends StatefulWidget {
  @override
  _RotatingIconState createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Icon(Icons.settings, color: Colors.white, size: 32),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
