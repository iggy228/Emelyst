import 'package:emelyst/model/FamilyMember.dart';
import 'package:emelyst/model/Floor.dart';
import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:mysql1/mysql1.dart';

class HomeData {
  static List<Floor> _floors = [];
  static List<FamilyMember> _users;

  static List<FamilyMember> get allUsers {
    return _users;
  }

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
      case 'svetlo':
        return SensorType.light;
      case 'motorcek':
        return SensorType.engine;
      case 'alarm':
        return SensorType.alarm;
      case 'servo':
        return SensorType.servo;
    }
    return SensorType.light;
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

  static String getSensorName(String name) {
    if (name == 'motorcek') return 'motorček';
    return name;
  }

  static String getRoomName(String floor, String room) {
    String txt = "${floor == 'prizemie' ? 'prízemie' : floor}\n";
    switch (room) {
      case 'kupelna':
        txt += 'kúpeľna';
        break;
      case 'satnik':
        txt += 'šatník';
        break;
      case 'spalna':
        txt += 'spáľna';
        break;
      case 'garaz':
        txt += 'garáž';
        break;
      case 'kuchyna':
        txt += 'kuchyňa';
        break;
      case 'obyvacka':
        txt += 'obývačka';
        break;
      case 'pracovna':
        txt += 'pracovňa';
        break;
      default:
        txt += room;
        break;
    }
    return txt;
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

  static void setData(List<Row> data, [List<FamilyMember> users]) {
    if (users == null) {
      _users = [];
    }
    else {
      _users = users;
    }

    String lastroom = '';
    String lastfloor = '';

    for (var row in data) {
      List<String> paths = row['topic'].split('/');

      if (lastfloor != paths[1]) {
        _floors.add(Floor(name: paths[1], rooms: <Room>[]));
        lastfloor = paths[1];
      }

      if (lastroom != paths[2] && paths[2] != 'linka') {
        String roomName = getRoomName(paths[1], paths[2]);
        _floors.last.rooms.add(Room(
            name: roomName,
            iconName: textToIconName(paths[2]),
            sensors: <Sensor<bool>>[]));
        lastroom = paths[2];
      }

      _floors.last.rooms.last.sensors.add(Sensor<bool>(
          name: getSensorName(paths[3]),
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
