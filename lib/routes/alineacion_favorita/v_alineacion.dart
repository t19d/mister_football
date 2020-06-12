import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/alineacion_favorita/w_campo_jugadores.dart';

class Alineacion extends StatefulWidget {
  Alineacion({Key key}) : super(key: key);

  @override
  _Alineacion createState() => _Alineacion();
}

class _Alineacion extends State<Alineacion> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

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
            'Alineación favorita',
          ),
          /*actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.yellow,
              ),
              tooltip: 'Guardar',
              onPressed: () {},
            ),
          ],*/
        ),
        body: CampoJugadores(),
        ),
    );
  }
}
