import 'package:emelyst/widgets/rgb_slider.dart';
import 'package:flutter/material.dart';

class RoadCard extends StatefulWidget {
  final bool data;

  RoadCard({this.data});

  @override
  _RoadCardState createState() => _RoadCardState();
}

class _RoadCardState extends State<RoadCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Príjazdova cesta',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Emelyst',
                fontSize: 24,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Stav',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    FlatButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      onPressed: () {},
                      child: Text(
                        widget.data ? 'vypnúť' : 'zapnúť',
                        style: TextStyle(
                          fontFamily: 'Emelyst',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    RGBSlider(),
                  ],
                ),
                Image.asset(
                  widget.data ? 'icons/road_on.png' : 'icons/road_off.png',
                  width: 100,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
