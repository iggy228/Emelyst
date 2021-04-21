import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoorCard extends StatelessWidget {
  final String name;
  final String stateText;
  final String stateIcon;
  final String buttonText;
  final Widget animatedIcon;
  final Function onClick;

  DoorCard({
    this.name,
    this.stateText,
    this.stateIcon,
    this.onClick,
    this.buttonText,
    this.animatedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
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
                    name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "Stav $stateText",
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        color: Colors.white,
                        onPressed: onClick,
                        child: Text(
                          buttonText,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      const SizedBox(width: 8),
                      if (animatedIcon != null) animatedIcon,
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  stateIcon
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
