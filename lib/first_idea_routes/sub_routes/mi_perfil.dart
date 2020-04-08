import 'package:flutter/material.dart';

class MiPerfil extends StatefulWidget {
  @override
  createState() => _MiPerfil();
}

class _MiPerfil extends State<MiPerfil> {
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
