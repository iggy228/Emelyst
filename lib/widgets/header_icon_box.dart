import 'package:flutter/material.dart';

class HeaderIconBox extends StatelessWidget {
  final String iconUrl;
  final String name;
  final double iconWidth;

  HeaderIconBox({this.name, this.iconUrl, this.iconWidth = 30});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(38, 0, 38, 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.vertical(bottom: const Radius.circular(999))
        ),
        child: Hero(
          tag: 'Emelyst-$name',
          child: Image.asset(iconUrl, width: iconWidth, color: Colors.white),
        ),
      ),
    );
  }
}
