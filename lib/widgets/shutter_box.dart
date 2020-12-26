import 'package:flutter/material.dart';

class ShutterBox extends StatelessWidget {
  final String name;
  final bool data;

  ShutterBox({this.name, this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyText1
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Image.asset(
              data ? 'icons/shutter_open.png' : 'icons/shutter_close.png',
              width: 50,
            ),
          ),
          FlatButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: () {},
            child: Text(
              data ? 'zatvoriť' : 'otvoriť',
            ),
          ),
        ],
      ),
    );
  }
}
