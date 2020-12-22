import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoorCard extends StatelessWidget {
  final String name;
  final bool data;
  final String openIcon;
  final String closeIcon;

  DoorCard({this.name, this.data, this.openIcon, this.closeIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Emelyst',
                    ),
                  ),
                  Text(
                    "Stav ${data ? 'otvorená' : 'zatvorená'}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Emelyst',
                    ),
                  ),
                  SizedBox(height: 32),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {},
                    child: Text(
                      data ? 'zatvoriť' : 'otvoriť',
                      style: TextStyle(fontFamily: 'Emelyst'),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  data ? openIcon : closeIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
