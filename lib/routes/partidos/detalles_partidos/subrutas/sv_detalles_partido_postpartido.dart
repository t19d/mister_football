import 'package:flutter/material.dart';

class DetallesPartidoPostpartido extends StatefulWidget {
  @override
  createState() => _DetallesPartidoPostpartido();
}

class _DetallesPartidoPostpartido extends State<DetallesPartidoPostpartido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.filter_frames,
            size: 200,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
