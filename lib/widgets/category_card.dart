import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String routeName;

  CategoryCard({this.title, this.imageUrl, this.routeName});

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/$routeName'),
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      icon: Hero(
        tag: 'Emelyst-$imageUrl',
        child: Image.asset(
          'icons/$imageUrl.png',
        ),
      ),
      label: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Emelyst',
          fontSize: 20,
        ),
      ),
    );
  }
}
