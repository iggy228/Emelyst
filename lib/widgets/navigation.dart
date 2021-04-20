import 'package:emelyst/pages/loading.dart';
import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
            icon: Image.asset('icons/home.png'),
            iconSize: 30,
          ),
          const SizedBox(width: 32),
          Image.asset('images/logo.png', height: 30),
          const SizedBox(width: 32),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Loading(whereLoading: WhereLoading.SETTINGS)),
            ),
            icon: Image.asset('icons/settings.png'),
          ),
        ],
      ),
    );
  }
}
