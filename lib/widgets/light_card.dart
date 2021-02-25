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

  double sizeOfIcon(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width < 300) {
      return title.length > 9 ? 42 : 55;
    }
    else {
      return title.length > 9 ? 55 : 65;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.fromLTRB(16, 16, 12, 8),
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
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                iconUrl,
                width: sizeOfIcon(context),
                height: sizeOfIcon(context),
              ),
            ),
            Card(
              color: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
