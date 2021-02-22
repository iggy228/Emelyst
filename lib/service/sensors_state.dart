import 'package:mysql1/mysql1.dart';

class SensorState {
  static MySqlConnection mysqlConn;

  static Future<bool> connect(String url, int port) async {
    ConnectionSettings settings = ConnectionSettings(
        host: url,
        port: port,
        user: 'david',
        password: 'barta',
        db: 'dht'
    );

    try {
      mysqlConn = await MySqlConnection.connect(settings);
      print('Connected');
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

  static Future<List<double>> getAvgTemperature() async {
    Results result = await mysqlConn.query('SELECT datum, tmp FROM teplota WHERE datum >= CURRENT_DATE() - 6');
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

  static Future<double> getLastTemperature() async {
    Results result = await mysqlConn.query('SELECT tmp FROM teplota ORDER BY ID DESC LIMIT 1');
    return result.last['tmp'];
  }

  static Future<double> getLastHumidity() async {
    Results result = await mysqlConn.query('SELECT hodnota FROM vlhkost ORDER BY ID DESC LIMIT 1');
    return result.last['hodnota'];
  }
}