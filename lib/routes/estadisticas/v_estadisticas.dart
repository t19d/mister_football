import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/estadisticas/w_estadisticas_goles.dart';
import 'package:mister_football/routes/estadisticas/w_estadisticas_resultados.dart';

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
            icon: Icon(Icons.menu),
            tooltip: 'Menú',
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
          title: Text(
            'Estadísticas',
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: Hive.openBox('partidos'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Container(
                    width: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .5,
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      EstadisticasResultados(),
                      EstadisticasGoles(),
                    ],
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
