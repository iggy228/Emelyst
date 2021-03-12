import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String prevRouteUrl;
  final Map prevRouteData;
  final String nextRouteUrl;
  final Map nextRouteData;

  Header({
    this.title,
    this.prevRouteUrl,
    this.prevRouteData,
    this.nextRouteData,
    this.nextRouteUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, prevRouteUrl, arguments: prevRouteData),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.arrow_forward_rounded,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, nextRouteUrl, arguments: nextRouteData),
          ),
        ],
      ),
    );
  }
}
