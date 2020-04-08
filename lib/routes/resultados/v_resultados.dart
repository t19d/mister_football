import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/resultados/w_lista_resultados.dart';

class Resultados extends StatefulWidget {
  Resultados({Key key}) : super(key: key);

  @override
  _Resultados createState() => _Resultados();
}

class _Resultados extends State<Resultados> {
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
        body: ListaResultados(),
      ),
    );
  }
}
