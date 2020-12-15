import 'package:emelyst/components/header.dart';
import 'package:emelyst/components/navigation.dart';
import 'package:emelyst/components/radial_background.dart';
import 'package:emelyst/model/Light.dart';
import 'package:flutter/material.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {

  List lights = [
    Light(name: 'kuchyna', data: false),
    Light(name: 'spalna', data: false),
    Light(name: 'garaz', data: false),
    Light(name: 'obyvacka', data: false),
  ];

  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Header(title: 'Svetlá'),
          Expanded(
            child: GridView.builder(
              itemCount: lights.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          lights[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Emelyst',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            lights[index].data ? 'icons/light_on.png' : 'icons/light_off.png',
                            width: 70,
                            height: 70,
                          ),
                        ),
                        Card(
                          color: lights[index].data ? Colors.amberAccent : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              lights[index].data ? 'on' : 'off',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Emelyst'
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }
}
