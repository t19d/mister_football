import 'package:flutter/material.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/gestion_jugadores/gestion_jugadores_edicion_creacion/v_gestion_jugadores_creacion.dart';
import 'package:mister_football/routes/gestion_jugadores/w_lista_gestion_jugadores.dart';

class GestionJugadores extends StatefulWidget {
  GestionJugadores({Key key}) : super(key: key);

  @override
  _GestionJugadores createState() => _GestionJugadores();
}

class _GestionJugadores extends State<GestionJugadores> {
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
            'Gestión jugadores',
          ),
          actions: <Widget>[
            /*IconButton(
              icon: const Icon(
                Icons.add_to_photos,
                color: Colors.yellowAccent,
              ),
              tooltip: 'Jugadoras/es sancionadas/os',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.add_box,
                color: Colors.redAccent,
              ),
              tooltip: 'Jugadores/as lesionados/as',
              onPressed: () {},
            ),*/
            IconButton(
              icon: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
              tooltip: 'Nuevo jugador/a',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GestionJugadoresCreacion()),
                );
              },
            ),
          ],
        ),
        body: ListaGestionJugadores(),
      ),
    );
  }
}
