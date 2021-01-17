enum SensorType {
  light,
  engine,
  detector,
  servo,
}

class Sensor<T> {
  String name;
  T data;
  String topic;
  SensorType sensorType;

  Sensor({
    this.name,
    this.data,
    this.topic = '',
    this.sensorType
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'data': data,
      'topic': topic,
      'sensorType': sensorType,
    };
  }
}