import 'package:flutter/material.dart';

class DetallesPartidoConvocatoria extends StatefulWidget {
  @override
  createState() => _DetallesPartidoConvocatoria();
}

class _DetallesPartidoConvocatoria extends State<DetallesPartidoConvocatoria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.watch_later,
            size: 200,
            color: Colors.lightGreen,
          ),
        ),
      ),
    );
  }
}
