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
    }
    return 'bedroom';
  }

  static void setData(List<Row> data) {

    String lastroom = '';
    String lastfloor = '';

    for (var row in data) {
      List<String> paths = row['topic'].split('/');

      if (lastfloor != paths[1]) {
        _floors.add(Floor(name: paths[1], rooms: <Room>[]));
        lastfloor = paths[1];
      }

      if (lastroom != paths[2]) {
        _floors.last.rooms.add(Room(
          name: paths[2],
          iconName: textToIconName(paths[2]),
          sensors: <Sensor<bool>>[]
        ));
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
    List<String> subTopics = topic.split('/');

    for (Floor floor in _floors) {
      if (floor.name == subTopics[1]) {
        for (Room room in floor.rooms) {
          if (room.name == subTopics[2]) {
            for (Sensor sensor in room.sensors) {
              if (sensor.name == subTopics[3]) {
                sensor.data = message == 'on' ? true : false;
              }
            }
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