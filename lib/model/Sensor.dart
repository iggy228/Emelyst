class Sensor<T> {
  String name;
  T data;
  String prefix;

  Sensor({
    this.name,
    this.data,
    this.prefix = '',
  });
}