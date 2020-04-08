import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';

class Equipo extends StatefulWidget {
  Equipo({Key key}) : super(key: key);

  @override
  _Equipo createState() => _Equipo();
}

class _Equipo extends State<Equipo> {
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
            icon: const Icon(Icons.menu),
            tooltip: 'Menú',
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
          title: Text(
            'Equipo',
          ),
        ),
        body: Text("Equipo"),
      ),
    );
  }
}
