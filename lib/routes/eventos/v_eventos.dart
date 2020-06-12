import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/eventos/w_eventos_calendario.dart';

class VentanaEventos extends StatefulWidget {
  VentanaEventos({Key key}) : super(key: key);

  @override
  _Eventos createState() => _Eventos();
}

class _Eventos extends State<VentanaEventos> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map listaEventosAEnviar = {};
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
            'Eventos',
          ),
        ),
        body: FutureBuilder(
          future: Hive.openBox('eventos'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else {
                var boxEventos = Hive.box('eventos');
                if (boxEventos.get(0) != null) {
                  Eventos eventosActuales = boxEventos.get(0);
                  listaEventosAEnviar = eventosActuales.listaEventos;
                }
                return EventosCalendario(listaEventos: listaEventosAEnviar);
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
