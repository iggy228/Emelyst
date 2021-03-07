import 'dart:math';
import 'package:emelyst/service/home_data.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClientWrapper {
  static MqttClient _client;
  static String _url = '';
  static String _id = '';
  static int _port;
  static bool isConnected = false;
  static String defaultPrefix = 'EMELYST/';

  static String get url {
    return _url;
  }

  static int get port {
    return _port;
  }

  static Future<void> connect({String url, int port = 1883}) async {
    int id = Random().nextInt(100000) + 1;
    _id = 'mobileId-$id';
    _url = url;
    _port = port;
    _client = MqttServerClient.withPort(_url, _id, _port);
    _client.keepAlivePeriod = 6000;
    _client.autoReconnect = true;

    try {
      await _client.connect();
      isConnected = true;
    } catch (e) {
      isConnected = false;
    }

    _client.onDisconnected = () => _client.doAutoReconnect();

    getMessage(null);
  }

  static void subscribe(String topic) {
    _client.subscribe(defaultPrefix + topic, MqttQos.atLeastOnce);
  }
  
  static void unsubscribe(String topic) => _client.unsubscribe(defaultPrefix + topic);

  static void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(defaultPrefix + topic, MqttQos.atLeastOnce, builder.payload);
  }

  /// what have to do post update home data
  static void getMessage(Function(String topic, String message) func) {
    _client.updates.listen((event) {
      MqttPublishMessage message = event[0].payload;
      var data = MqttPublishPayload.bytesToStringAsString(message.payload.message);

      HomeData.updateData(event[0].topic, data);

      if (func != null) {
        func(event[0].topic, data);
      }

    });
  }
}