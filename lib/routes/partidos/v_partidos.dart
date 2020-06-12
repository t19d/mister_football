import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/v_partidos_creacion.dart';
import 'package:mister_football/routes/partidos/w_lista_partidos.dart';

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
            icon: Icon(Icons.menu),
            tooltip: 'Menú',
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.white,
              ),
              tooltip: 'Crear partido',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartidosCreacion(),
                  ),
                );
              },
            ),
          ],
          title: Text(
            'Partidos',
          ),
        ),
        body: ListaPartidos(),
      ),
    );
  }
}
