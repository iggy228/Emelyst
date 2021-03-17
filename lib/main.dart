import 'package:emelyst/pages/home.dart';
import 'package:emelyst/pages/lights.dart';
import 'package:emelyst/pages/loading.dart';
import 'package:emelyst/pages/error_page.dart';
import 'package:emelyst/pages/overview.dart';
import 'package:emelyst/pages/room_page.dart';
import 'package:emelyst/pages/security.dart';
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
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => Loading(),
        '/home': (context) => Home(),
        '/lights': (context) => Lights(),
        '/overview': (context) => Overview(),
        '/security': (context) => Security(),
        '/room': (context) => RoomPage(),
        '/settings': (context) => Settings(),
        '/loadingError': (context) => ErrorPage(),
      },
      theme: ThemeData(
        fontFamily: 'Emelyst',
        primaryColor: Color.fromRGBO(52, 192, 209, 1),
        textTheme: TextTheme(
          headline3: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'GillSans'
          ),
          headline4: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          headline6: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'GillSans'
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white60),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white,  width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white,  width: 2),
          ),
        ),
      ),
    );
  }
}
