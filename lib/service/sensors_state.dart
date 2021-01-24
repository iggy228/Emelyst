import 'package:mysql1/mysql1.dart';

class SensorState {
  static MySqlConnection mysqlConn;

  static Future<void> connect() async {
    ConnectionSettings settings = ConnectionSettings(
        host: '91.127.172.175',
        port: 3306,
        user: 'david',
        password: 'barta',
        db: 'dht'
    );

    mysqlConn = await MySqlConnection.connect(settings);
  }

  static Future<List> getData() async {
    Results result = await mysqlConn.query('SELECT * FROM stav');
    return result.toList();
  }

  static Future<List> updateState(List sensors) async {
    Results result = await mysqlConn.query('SELECT * FROM stav');

    for (var row in result) {
      sensors.forEach((sensor) {
        if (row['topic'].contains(sensor.topic)) {
          sensor.data = row['stav'] == 'on' ? true : false;
        }
      });
    }

    return sensors;
  }
}