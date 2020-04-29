import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:mister_football/routes/entrenamientos/entrenamientos_edicion_creacion/v_entrenamientos_creacion.dart';
import 'package:mister_football/routes/entrenamientos/w_lista_entrenamientos.dart';

class Entrenamientos extends StatefulWidget {
  Entrenamientos({Key key}) : super(key: key);

  @override
  _Entrenamientos createState() => _Entrenamientos();
}

class _Entrenamientos extends State<Entrenamientos> {
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
            'Entrenamientos',
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              tooltip: 'Crear entrenamiento',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntrenamientosCreacion(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListaEntrenamientos(),
      ),
    );
  }
}
