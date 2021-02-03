import 'package:mysql1/mysql1.dart';

class SensorState {
  static MySqlConnection mysqlConn;

  static Future<bool> connect(String url) async {
    ConnectionSettings settings = ConnectionSettings(
        host: url,
        port: 3306,
        user: 'david',
        password: 'barta',
        db: 'dht'
    );

    try {
      mysqlConn = await MySqlConnection.connect(settings);
      return true;
    }
    catch (_) {
      return false;
    }
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

  static Future<List<double>> getAvgTemperature() async {
    Results result = await mysqlConn.query('SELECT datum, tmp FROM teplota WHERE datum >= CURRENT_DATE() - 6');
    print(result.length);
    List<double> avgTemperatures = [];

    double sumTemp = 0.0;
    int count = 0;
    int lastDate;
    for (var row in result) {
      if (lastDate != row['datum'].day || lastDate == null) {
        if (lastDate != null) {
          avgTemperatures.add(sumTemp / count);
        }
        sumTemp = row['tmp'];
        count = 1;
        lastDate = row['datum'].day;
      }
      else {
        sumTemp += row['tmp'];
        count++;
      }
    }

    avgTemperatures.add(sumTemp / count);

    return avgTemperatures;
  }
}