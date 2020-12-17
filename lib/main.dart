import 'package:emelyst/pages/home.dart';
import 'package:emelyst/pages/lights.dart';
import 'package:emelyst/pages/loading.dart';
import 'package:emelyst/pages/overview.dart';
import 'package:emelyst/pages/room.dart';
import 'package:emelyst/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(Emelyst());

class Emelyst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/lights': (context) => Lights(),
        '/overview': (context) => Overview(),
        '/room': (context) => Room(),
        '/settings': (context) => Settings(),
      },
    );
  }
}
