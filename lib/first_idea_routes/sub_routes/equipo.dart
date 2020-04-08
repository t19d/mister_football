import 'package:flutter/material.dart';

class Equipo extends StatefulWidget {
  @override
  createState() => _Equipo();
}

class _Equipo extends State<Equipo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.threed_rotation,
            size: 200,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
