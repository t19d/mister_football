import 'package:flutter/material.dart';

class Historial extends StatefulWidget {
  @override
  createState() => _Historial();
}

class _Historial extends State<Historial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.history,
            size: 200,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
