import 'package:emelyst/model/Room.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/widgets/category_card.dart';
import 'package:emelyst/widgets/home_scroll_view.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/room_card.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String floorPrefix = 'prizemie/';

  List<Map<String, String>> categories = [
    {'name': 'Domov', 'icon': 'info', 'url': '/overview'},
    {'name': 'Svetlá', 'icon': 'light', 'url': '/lights'},
    {'name': 'Ochrana', 'icon': 'security', 'url': '/security'},
  ];

  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      rooms = HomeData.allRoomsData;
    }

    return RadialBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(),
          Expanded(
            child: HomeScrollView(
              header: Container(
                margin: const EdgeInsets.only(top: 24, bottom: 24),
                height: 60,
                color: const Color.fromRGBO(0, 0, 0, 0.4),
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: CategoryCard(
                        title: categories[i]['name'],
                        imageUrl: categories[i]['icon'],
                        onPress: () {
                          Navigator.pushNamed(context, categories[i]['url'], arguments: {
                            "categories": categories,
                            "index": i,
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              itemCount: rooms.length,
              itemBuilder: (BuildContext context, int index) {
                return RoomCard(
                  title: rooms[index].name,
                  imageUrl: rooms[index].iconName,
                  routeData: {
                    'index': index,
                    'roomsData': rooms
                  },
                );
              },
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    rooms = [];
    super.dispose();
  }
}
