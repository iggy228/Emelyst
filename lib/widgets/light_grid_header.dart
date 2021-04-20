import 'package:flutter/material.dart';

class LightGridHeader extends StatelessWidget {
  final String title;
  final String iconUrl;

  LightGridHeader({
    this.title,
    this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(width: 16),
          Image.asset(
            iconUrl,
          ),
        ],
      ),
    );
  }
}
