import 'package:flutter/material.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Configuracion extends StatefulWidget {
  Configuracion({Key key}) : super(key: key);

  @override
  _Configuracion createState() => _Configuracion();
}

class _Configuracion extends State<Configuracion> {
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
            onPressed: () async {
              _drawerKey.currentState.openDrawer();
              //Pruebas de Hive
              /*var box = await Hive.openBox('test');

              box.put('name', 'David');

              print('Name: ${box.get('name')}');*/
            },
          ),
          title: Text(
            'Configuración',
          ),
        ),
        body: Text("Configuración"),
      ),
    );
  }

  /*
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }*/
}
