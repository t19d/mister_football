import 'package:flutter/material.dart';

class DetallesPartidoAlineacion extends StatefulWidget {
  @override
  createState() => _DetallesPartidoAlineacion();
}

class _DetallesPartidoAlineacion extends State<DetallesPartidoAlineacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.error,
            size: 200,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}
