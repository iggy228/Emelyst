import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [
    {'name': 'Prehľad', 'icon': 'home', 'url': 'overview'},
    {'name': 'Svetlá', 'icon': 'light', 'url': 'lights'},
  ];

  List rooms = [
    {'name': 'Obývačka', 'icon': 'hostroom'},
    {'name': 'Kuchyňa', 'icon': 'kitchen'},
    {'name': 'Spálňa', 'icon': 'bedroom'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 2,
              colors: [
                Color.fromRGBO(52, 192, 209, 1),
                Color.fromRGBO(26, 94, 103, 1),
              ],
              stops: [
                0.1,
                1
              ]
            )
          ),
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
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Emelyst',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'vaša inteligentná domácnosť',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Emelyst',
                          color: Colors.white
                        ),
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
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24, bottom: 24),
                height: 60,
                color: Color.fromRGBO(0, 0, 0, 0.4),
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: FlatButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/${categories[index]["url"]}'),
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        icon: Image.asset(
                          'icons/${categories[index]["icon"]}.png',
                        ),
                        label: Text(
                          categories[index]["name"],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Emelyst',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/${rooms[index]['icon']}.png'),
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rooms[index]['name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Emelyst',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Image.asset('icons/${rooms[index]['icon']}.png', width: 90, height: 90,)
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
