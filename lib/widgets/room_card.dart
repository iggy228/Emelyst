import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  RoomCard({this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/room'),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/$imageUrl.png'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 8),
            Image.asset('icons/$imageUrl.png', width: 90, height: 90)
          ],
        ),
      ),
    );
  }
}
