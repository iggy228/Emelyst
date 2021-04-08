import 'package:emelyst/model/Floor.dart';
import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:mysql1/mysql1.dart';

class HomeData {
  static List<Floor> _floors = [];

  static List<Floor> get allData {
    return _floors;
  }

  static List<Room> get allRoomsData {
    List<Room> rooms = [];

    for (Floor floor in _floors) {
      print(floor.rooms.length);
      rooms.addAll(floor.rooms);
    }

    return rooms;
  }

  static SensorType textToSensorType(String text) {
    switch (text) {
      case 'svetlo': return SensorType.light;
      case 'motorcek': return SensorType.engine;
      case 'pohyb': return SensorType.detector;
      case 'servo': return SensorType.servo;
    }
    return null;
  }

  static String textToIconName(String text) {
    switch (text) {
      case 'obyvacka': return 'hostroom';
      case 'spalna': return 'bedroom';
      case 'kuchyna': return 'kitchen';
      case 'garaz': return 'garage';
      case 'prijazd': return 'garage';
      case 'vchod': return 'garage';
      case 'pracovna': return 'workroom';
      case 'kupelka': return 'bathroom';
      case 'detska_izba': return 'kidsroom';
      case 'chodba': return 'hallway';
    }
    return 'bedroom';
  }

  static List<Sensor> getSensorsInRoom(String roomName) {
    for (Floor floor in _floors) {
      for (Room room in floor.rooms) {
        if (room.name == roomName) {
          return room.sensors;
        }
      }
    }
    return [];
  }

  static void setData(List<Row> data, List<Row> roomsName) {

    String lastroom = '';
    String lastfloor = '';

    int roomsNameIndex = 0;

    for (var row in data) {
      List<String> paths = row['topic'].split('/');

      if (lastfloor != paths[1]) {
        _floors.add(Floor(name: paths[1], rooms: <Room>[]));
        lastfloor = paths[1];
      }

      if (lastroom != paths[2]) {
        String roomName = roomsName[roomsNameIndex]['nazov'].replaceAll(' ', '\n');
        _floors.last.rooms.add(Room(
          name: roomName,
          iconName: textToIconName(paths[2]),
          sensors: <Sensor<bool>>[]
        ));
        roomsNameIndex++;
        lastroom = paths[2];
      }

      _floors.last.rooms.last.sensors.add(Sensor<bool>(
        name: paths[3],
        data: row['stav'] == 'on' ? true : false,
        topic: '${paths[1]}/${paths[2]}/${paths[3]}',
        sensorType: textToSensorType(paths[3])
      ));
    }

    _setSubscribtion();
  }

  static void updateData(String topic, String message) {
    for (Floor floor in _floors) {
      for (Room room in floor.rooms) {
        for (Sensor sensor in room.sensors) {
          if (topic.contains(sensor.topic)) {
            sensor.data = message == 'on' ? true : false;
            return;
          }
        }
      }
    }
  }

  static void _setSubscribtion() {
    for (Floor floor in _floors) {
      for (Room room in floor.rooms) {
        for (Sensor sensor in room.sensors) {
          MqttClientWrapper.subscribe(sensor.topic);
        }
      }
    }
  }
}