import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context).settings.arguments;
    return Container(
      color: Color.fromRGBO(52, 192, 209, 1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text("$message :(", style: Theme.of(context).textTheme.headline5)
        ),
      ),
    );
  }
}
