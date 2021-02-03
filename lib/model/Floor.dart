import 'package:emelyst/model/Room.dart';

class Floor {
  String name;
  List<Room> rooms;

  Floor({this.name, this.rooms});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rooms': rooms
    };
  }
}