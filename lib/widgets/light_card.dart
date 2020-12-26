import 'package:flutter/material.dart';

class LightCard extends StatelessWidget {
  final String title;
  final bool data;
  final Function onPress;

  LightCard({this.title, this.data, this.onPress});

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
                data ? 'icons/light_on.png' : 'icons/light_off.png',
                width: 70,
                height: 70,
              ),
            ),
            Card(
              color: data ? Colors.amberAccent : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  data ? 'on' : 'off',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
