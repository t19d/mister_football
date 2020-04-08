import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';

class Partidos extends StatefulWidget {
  Partidos({Key key}) : super(key: key);

  @override
  _Partidos createState() => _Partidos();
}

class _Partidos extends State<Partidos> {
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
            'Partidos',
          ),
        ),
        body: Text("Partidos"),
      ),
    );
  }
}
