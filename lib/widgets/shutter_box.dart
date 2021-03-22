import 'package:flutter/material.dart';

class ShutterBox extends StatelessWidget {
  final String name;
  final bool data;
  final Function onClick;

  ShutterBox({this.name, this.data, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Image.asset(
            data ? 'icons/shutter_open.png' : 'icons/shutter_close.png',
            width: 50,
            height: 50,
            alignment: Alignment.topCenter,
          ),
          FlatButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: onClick,
            child: Text(
              data ? 'zatvoriť' : '  otvoriť ',
            ),
          ),
        ],
      ),
    );
  }
}
