import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/alineacion_favorita/w_campo_jugadores.dart';

class Alineacion extends StatefulWidget {
  static Map<String, dynamic> equipoEditado;

  Alineacion({Key key}) : super(key: key);

  @override
  _Alineacion createState() => _Alineacion();
}

class _Alineacion extends State<Alineacion> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  //Método que abre las boxes necesarias.
  Future<void> _openBox() async {
    await Hive.openBox("perfil");
    await Hive.openBox("jugadores");
  }

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
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              tooltip: 'Guardar',
              onPressed: () async {
                if (!Hive.isBoxOpen('perfil')) {
                  await Hive.openBox('perfil');
                }
                Box boxPerfil = Hive.box('perfil');
                if (boxPerfil.get(0) != null) {
                  boxPerfil.putAt(0, Alineacion.equipoEditado);
                } else {
                  boxPerfil.add(Alineacion.equipoEditado);
                }
              },
            ),
          ],
        ),
        //body: CampoJugadores(),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _openBox(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text(snapshot.error.toString());
                } else {
                  Box boxPerfil = Hive.box('perfil');
                  Map<String, dynamic> equipo = {
                    "nombre_equipo": "",
                    "escudo": "",
                    "modo_oscuro": false,
                    "alineacion_favorita": [
                      {'0': null, '1': null, '2': null, '3': null, '4': null, '5': null, '6': null, '7': null, '8': null, '9': null, '10': null},
                      "14231"
                    ]
                  };
                  if (boxPerfil.get(0) != null) {
                    equipo = Map.from(boxPerfil.get(0));
                  }
                  //Poner valor del static
                  Alineacion.equipoEditado = equipo;
                  return CampoJugadores();
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
