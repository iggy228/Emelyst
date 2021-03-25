import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          image: DecorationImage(
            image: AssetImage('images/header_img.png'),
            alignment: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 13, 0, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Víta Vás',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(
                'vaša inteligentná domácnosť',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}