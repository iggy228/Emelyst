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

  static Future<Map<String, double>> getAvgTemperature() async {
    Results result = await mysqlConn.query(
        'SELECT datum, tmp FROM teplota WHERE datum >= DATE(NOW()) - INTERVAL 7 DAY');
    Map<String, double> avgTemperatures = {};

    double sumTemp = 0.0;
    int count = 0;
    int lastDay;
    int lastMonth;
    for (var row in result) {
      if (lastDay != row['datum'].day || lastDay == null) {
        if (lastDay != null) {
          avgTemperatures['$lastDay.$lastMonth'] = sumTemp / count;
        }
        sumTemp = row['tmp'];
        count = 1;
        lastDay = row['datum'].day;
        lastMonth = row['datum'].month;
      } else {
        sumTemp += row['tmp'];
        count++;
      }
    }

    avgTemperatures['${result.last["datum"].day}.${result.last["datum"].month}'] = sumTemp / count;

    return avgTemperatures;
  }

  static Future<Map<String, double>> getAvgHumidity() async {
    Results result = await mysqlConn.query(
        'SELECT date, hodnota FROM vlhkost WHERE date >= DATE(NOW()) - INTERVAL 7 DAY');
    Map<String, double> avgHumidity = {};

    double sumHumidity = 0.0;
    int count = 0;
    int lastDay;
    int lastMonth;
    for (var row in result) {
      if (lastDay != row['date'].day || lastDay == null) {
        if (lastDay != null) {
          avgHumidity['$lastDay.$lastMonth'] = sumHumidity / count;
        }
        sumHumidity = row['hodnota'];
        count = 1;
        lastDay = row['date'].day;
        lastMonth = row['date'].month;
      } else {
        sumHumidity += row['hodnota'];
        count++;
      }
    }

    avgHumidity['${result.last["date"].day}.${result.last["date"].month}'] = sumHumidity / count;

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
