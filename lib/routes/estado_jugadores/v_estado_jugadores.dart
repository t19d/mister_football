import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/estado_jugadores/w_lista_estado_jugadores.dart';

class EstadoJugadores extends StatefulWidget {
  EstadoJugadores({Key key}) : super(key: key);

  @override
  _EstadoJugadores createState() => _EstadoJugadores();
}

class _EstadoJugadores extends State<EstadoJugadores> {
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
            'Estado jugadores',
          ),
        ),
        body: ListaEstadoJugadores(),
      ),
    );
  }
}
