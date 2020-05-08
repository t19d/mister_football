import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/estadisticas/w_estadisticas_goles.dart';

class Estadisticas extends StatefulWidget {
  Estadisticas({Key key}) : super(key: key);

  @override
  _Estadisticas createState() => _Estadisticas();
}

class _Estadisticas extends State<Estadisticas> {
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
            'Resultados',
          ),
        ),
        body: EstadisticasGoles(),
      ),
    );
  }
}
