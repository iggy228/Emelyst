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

  List categories = [
    {'name': 'Prehľad', 'icon': 'home', 'url': 'overview'},
    {'name': 'Svetlá', 'icon': 'light', 'url': 'lights'},
    {'name': 'Ochrana', 'icon': 'security', 'url': 'security'},
  ];

  List rooms = [
    {'name': 'Obývačka', 'icon': 'hostroom', 'prefix': 'obyvacka'},
    {'name': 'Kuchyňa', 'icon': 'kitchen', 'prefix': 'kuchyna'},
    {'name': 'Spálňa', 'icon': 'bedroom', 'prefix': 'spalna'},
    {'name': 'Pracovňa', 'icon': 'bedroom', 'prefix': 'pracovna'},
    {'name': 'Chodba', 'icon': 'bedroom', 'prefix': 'chodba'},
    {'name': 'Šatník', 'icon': 'bedroom', 'prefix': 'satnik'},
    {'name': 'Kupeľna', 'icon': 'bedroom', 'prefix': 'kupelka'},
    {'name': 'Garáž', 'icon': 'bedroom', 'prefix': 'garaz'},
  ];

  List<String> getRoomsPrefixes() {
    List<String> roomsPrefixes = [];
    rooms.forEach((element) {
      roomsPrefixes.add(element['prefix']);
    });
    return roomsPrefixes;
  }

  @override
  Widget build(BuildContext context) {
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
                        routeName: categories[i]['url'],
                        routeData: {
                          "data": categories,
                          "index": i,
                          "prefix": floorPrefix,
                          "roomsPrefixes": getRoomsPrefixes(),
                        },
                      ),
                    );
                  },
                ),
              ),
              itemCount: rooms.length,
              itemBuilder: (BuildContext context, int index) {
                return RoomCard(
                  title: rooms[index]['name'],
                  imageUrl: rooms[index]['icon'],
                  routeData: {
                    "prefix": floorPrefix,
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
}
