import 'package:flutter/material.dart';

class LightCard extends StatelessWidget {
  final String title;
  final String text;
  final String iconUrl;
  final Function onPress;
  final Color color;

  LightCard({
    this.title,
    this.text,
    this.iconUrl,
    this.color,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                iconUrl,
                width: 70,
                height: 70,
              ),
            ),
            Card(
              color: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
