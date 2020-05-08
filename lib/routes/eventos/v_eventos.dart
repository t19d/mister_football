import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/eventos/w_eventos_calendario.dart';

class Eventos extends StatefulWidget {
  Eventos({Key key}) : super(key: key);

  @override
  _Eventos createState() => _Eventos();
}

class _Eventos extends State<Eventos> {
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
            'Eventos',
          ),
        ),
        body: EventosCalendario(),
      ),
    );
  }
}
