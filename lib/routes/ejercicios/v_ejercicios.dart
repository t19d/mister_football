import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/ejercicios/w_lista_ejercicios_json.dart';

class Ejercicios extends StatefulWidget {
  Ejercicios({Key key}) : super(key: key);

  @override
  _Ejercicios createState() => _Ejercicios();
}

class _Ejercicios extends State<Ejercicios> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        drawer: Drawer(
          child: Navegador(),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Menú',
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
          title: Text(
            'Ejercicios',
          ),
        ),
        body: ListaEjerciciosJSON(),
      ),
    );
  }
}
