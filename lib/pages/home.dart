import 'package:emelyst/model/Room.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/sensors_state.dart';
import 'package:emelyst/widgets/category_card.dart';
import 'package:emelyst/widgets/home_scroll_view.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/room_card.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String floorPrefix = 'prizemie/';

  List<Map<String, String>> categories = [
    {'name': 'Prehľad', 'icon': 'home', 'url': '/overview'},
    {'name': 'Svetlá', 'icon': 'light', 'url': '/lights'},
    {'name': 'Ochrana', 'icon': 'security', 'url': '/security'},
  ];

  List<Room> rooms = [];

  List<Map<String, dynamic>> getRoomsData() {
    List<Map<String, dynamic>> roomsData = [];
    rooms.forEach((room) {
      roomsData.add({'name': room.name, 'sensors': room.sensors});
    });
    return roomsData;
  }

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      rooms = HomeData.allRoomsData;
    }

    return RadialBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset('icons/avatar.png'),
                        iconSize: 40,
                        padding: EdgeInsets.fromLTRB(0, 8, 24, 4),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset('icons/bell.png'),
                        iconSize: 40,
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: HomeScrollView(
              header: Container(
                margin: EdgeInsets.only(top: 24, bottom: 24),
                height: 60,
                color: Color.fromRGBO(0, 0, 0, 0.4),
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
                            "data": categories,
                            "index": i,
                          });
                          setState(() {});
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
                    'roomData': rooms[index].toMap(),
                    'floorPrefix': floorPrefix,
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
    print(rooms);
    super.dispose();
  }
}
