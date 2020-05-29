import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';

class DetallesEjercicioJSON extends StatefulWidget {
  final Map<String, dynamic> datos;

  DetallesEjercicioJSON({Key key, @required this.datos}) : super(key: key);

  @override
  _DetallesEjercicioJSON createState() => _DetallesEjercicioJSON();
}

class _DetallesEjercicioJSON extends State<DetallesEjercicioJSON> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.datos['titulo'],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //Título
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Título: " + widget.datos['titulo']),
                    ConversorImagen.imageFromBase64String(widget.datos['imagen'], context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
