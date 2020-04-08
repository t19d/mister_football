import 'package:flutter/material.dart';

class Eventos extends StatefulWidget {
  @override
  createState() => _Eventos();
}

class _Eventos extends State<Eventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.event_seat,
            size: 200,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
