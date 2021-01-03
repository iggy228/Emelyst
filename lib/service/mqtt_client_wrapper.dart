import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClientWrapper {
  static MqttClient _client;
  static String _url = '';
  static String _id = '';
  static int _port = 1883;
  static bool isConnected = false;

  static String get url {
    return _url;
  }

  static Future<void> connect(String url) async {
    int id = Random().nextInt(100000) + 1;
    _id = 'mobileId-$id';
    _url = url;
    _client = MqttServerClient.withPort(_url, _id, _port);

    try {
      await _client.connect();
      isConnected = true;
    } catch (e) {
      isConnected = false;
    }
  }

  static void subscribe(String topic) => _client.subscribe(topic, MqttQos.atLeastOnce);
  
  static void unsubscribe(String topic) => _client.unsubscribe(topic);

  static void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  static void onMessage(Function(String, String) func) {
    _client.updates.listen((event) {
      MqttPublishMessage message = event[0].payload;
      var data = MqttPublishPayload.bytesToStringAsString(message.payload.message);

      func(event[0].topic, data);
    });
  }

}