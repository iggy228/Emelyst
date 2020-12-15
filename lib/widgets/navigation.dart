import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
            icon: Image.asset('icons/home.png'),
            iconSize: 30,
          ),
          SizedBox(width: 32),
          Image.asset('images/logo.png', height: 30),
          SizedBox(width: 32),
          IconButton(
            onPressed: () {},
            icon: Image.asset('icons/settings.png'),
          ),
        ],
      ),
    );
  }
}
