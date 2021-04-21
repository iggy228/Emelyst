import 'package:emelyst/model/FamilyMember.dart';
import 'package:mysql1/mysql1.dart';

class SensorState {
  static MySqlConnection mysqlConn;

  static Future<bool> connect(
      {String url,
      int port,
      String username,
      String password,
      String db}) async {
    ConnectionSettings settings = ConnectionSettings(
        host: url, port: port, user: username, password: password, db: db);

    try {
      mysqlConn = await MySqlConnection.connect(settings);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List> getData() async {
    Results result = await mysqlConn.query('SELECT * FROM stav ORDER BY topic');
    return result.toList();
  }
  
  static Future<List<FamilyMember>> getUsers() async {
    List<FamilyMember> users = [];

    Results results = await mysqlConn.query('SELECT uzivatel, cas, datum, stav FROM karta');
    for (var row in results) {
      int hours = row['cas'].inHours;
      int minutes = row['cas'].inMinutes - row['cas'].inHours * 60;
      int seconds = row['cas'].inSeconds - row['cas'].inMinutes * 60;
      users.add(FamilyMember(
        name: row['uzivatel'],
        isHome: row['stav'] == 1,
        iconUrl: 'images/${row["uzivatel"]}.png',
        date: DateTime(
          row['datum'].year,
          row['datum'].month,
          row['datum'].day,
          hours,
          minutes,
          seconds
        ),
      ));
    }
    return users;
  }

  static Future<List<double>> getAvgTemperature() async {
    Results result = await mysqlConn.query(
        'SELECT datum, tmp FROM teplota WHERE datum >= DATE(NOW()) - INTERVAL 31 DAY');
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
      } else {
        sumTemp += row['tmp'];
        count++;
      }
    }

    avgTemperatures.add(sumTemp / count);

    return avgTemperatures;
  }

  static Future<List<double>> getAvgHumidity() async {
    Results result = await mysqlConn.query(
        'SELECT date, hodnota FROM vlhkost WHERE date >= DATE(NOW()) - INTERVAL 31 DAY');
    List<double> avgHumidity = [];

    double sumHumidity = 0.0;
    int count = 0;
    int lastDate;
    for (var row in result) {
      if (lastDate != row['date'].day || lastDate == null) {
        if (lastDate != null) {
          avgHumidity.add(sumHumidity / count);
        }
        sumHumidity = row['hodnota'];
        count = 1;
        lastDate = row['date'].day;
      } else {
        sumHumidity += row['hodnota'];
        count++;
      }
    }

    avgHumidity.add(sumHumidity / count);

    return avgHumidity;
  }

  static Future<double> getLastTemperature() async {
    Results result = await mysqlConn
        .query('SELECT tmp FROM teplota ORDER BY ID DESC LIMIT 1');
    return result.last['tmp'];
  }

  static Future<double> getLastHumidity() async {
    Results result = await mysqlConn
        .query('SELECT hodnota FROM vlhkost ORDER BY ID DESC LIMIT 1');
    return result.last['hodnota'];
  }
}
