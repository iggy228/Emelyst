import 'package:flutter/material.dart';

class HeaderIconBox extends StatelessWidget {
  final String iconUrl;
  final String name;

  HeaderIconBox(this.name, this.iconUrl);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(38, 0, 38, 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(999))
        ),
        child: Hero(
          tag: 'Emelyst-$name',
          child: Image.asset(iconUrl, width: 30, color: Colors.white),
        ),
      ),
    );
  }
}
