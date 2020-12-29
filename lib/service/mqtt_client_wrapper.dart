import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClientWrapper {
  static MqttClient _client;

  static Future<void> connect(url) async {
    int id = Random().nextInt(100000) + 1;
    _client = MqttServerClient.withPort(url, 'mobileId-$id', 1883);

    try {
      await _client.connect();
    } catch (e) {
      print('This is your error: $e');
    }
  }

  static void subscribe(String topic) => _client.subscribe(topic, MqttQos.atLeastOnce);
  
  static void unsubscribe(String topic) => _client.unsubscribe(topic);

  static void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
    print('Message publish');
  }

  static void onMessage(Function(String, String) func) {
    _client.updates.listen((event) {
      MqttPublishMessage message = event[0].payload;
      var data = MqttPublishPayload.bytesToStringAsString(message.payload.message);

      func(event[0].topic, data);
    });
  }

}