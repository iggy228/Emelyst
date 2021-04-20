import 'package:flutter/material.dart';

class FamilyMemberBox extends StatelessWidget {
  final String name;
  final String stateText;
  final String timeText;
  final String avatarIcon;

  FamilyMemberBox({
    this.name,
    this.stateText,
    this.timeText,
    this.avatarIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: <Widget>[
          Text(name, style: Theme.of(context).textTheme.headline5),
          Image.asset(avatarIcon, width: 50),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Text('Stav ', style: Theme.of(context).textTheme.headline6),
              Text(stateText, style: TextStyle(fontSize: 18, fontFamily: 'Edition', color: Theme.of(context).primaryColor)),
            ],
          ),
          Text('Posledná aktivita', style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'GillSans')),
          Row(
            children: <Widget>[
              Text('Pred ', style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'GillSans')),
              Text(timeText, style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor, fontFamily: 'GillSans')),
            ],
          ),
        ],
      ),
    );
  }
}
