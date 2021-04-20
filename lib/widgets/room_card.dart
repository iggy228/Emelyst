import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Map routeData;

  RoomCard({this.title, this.imageUrl, this.routeData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/room', arguments: routeData),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
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
            const SizedBox(height: 8),
            Image.asset('icons/$imageUrl.png', width: 90, height: 90)
          ],
        ),
      ),
    );
  }
}
