import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomSensorCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final String buttonText;
  final Color buttonColor;
  final String stateText;
  final Function onPress;

  RoomSensorCard({
    this.title,
    this.iconUrl,
    this.onPress,
    this.stateText,
    this.buttonText,
    this.buttonColor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 8),
                  const Text("Stav"),
                  Text(
                    stateText,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(height: 32),
                  FlatButton(
                    color: buttonColor,
                    onPressed: onPress,
                    child: Text(buttonText),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(iconUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
