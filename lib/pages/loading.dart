import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupConnectionToBroker() async {
    await MqttClientWrapper.connect('test.mosquitto.org');
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    setupConnectionToBroker();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(52, 192, 209, 1),
      child: Center(
        child: SpinKitFoldingCube(
          color: Colors.white
        ),
      ),
    );
  }
}
