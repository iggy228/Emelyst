import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onPress;

  CategoryCard({
    this.title,
    this.imageUrl,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      onPressed: onPress,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      icon: Hero(
        tag: 'Emelyst-$imageUrl',
        child: Image.asset(
          'icons/$imageUrl.png',
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.only(top: 4, left: 4),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }
}
