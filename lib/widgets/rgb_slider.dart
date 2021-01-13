import 'package:flutter/material.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({RenderBox parentBox, Offset offset = Offset.zero, SliderThemeData sliderTheme, bool isEnabled = false, bool isDiscrete = false}) {
    return Rect.fromLTWH(10, 0, parentBox.size.width - 20, parentBox.size.height);
  }
}

class RGBSlider extends StatefulWidget {
  @override
  _RGBSliderState createState() => _RGBSliderState();
}

class _RGBSliderState extends State<RGBSlider> {
  double sliderVal = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(56),
        gradient: LinearGradient(
          colors: [
            Colors.red[600],
            Colors.green[600],
            Colors.blue[600],
          ],
        ),
      ),
      child: SliderTheme(
        data: SliderThemeData(
          thumbColor: Colors.white,
          inactiveTrackColor: Colors.transparent,
          activeTrackColor: Colors.transparent,
          trackHeight: 0,
          trackShape: CustomTrackShape(),
        ),
        child: Slider(
          value: sliderVal,
          onChanged: (double value) {
            setState(() {
              sliderVal = value;
            });
          },
        ),
      ),
    );
  }
}
