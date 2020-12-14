import 'package:flutter/material.dart';

class RadialBackground extends StatelessWidget {
  Widget child;

  RadialBackground({this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2,
                colors: [
                  Color.fromRGBO(52, 192, 209, 1),
                  Color.fromRGBO(26, 94, 103, 1),
                ],
                stops: [
                  0.1,
                  1
                ],
              )
          ),
          child: child,
        ),
      ),
    );
  }
}
