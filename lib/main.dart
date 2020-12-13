import 'package:emelyst/pages/home.dart';
import 'package:emelyst/pages/lights.dart';
import 'package:emelyst/pages/loading.dart';
import 'package:emelyst/pages/overview.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
    '/lights': (context) => Lights(),
    '/overview': (context) => Overview(),
  },
));