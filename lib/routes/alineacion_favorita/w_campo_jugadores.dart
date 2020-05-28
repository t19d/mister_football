import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/routes/alineacion_favorita/w_formaciones.dart';

class CampoJugadores extends StatefulWidget {
  CampoJugadores({Key key}) : super(key: key);

  @override
  createState() => _CampoJugadores();
}

class _CampoJugadores extends State<CampoJugadores> {
  int columnas = 0;
  int filas = 0;
  String _formacionActual;
  List<DropdownMenuItem<String>> _formacionesDisponibles;
  List _formaciones = ["14231", "1442", "1433", "1451", "1532", "1523", "13232", "1352", "1334"];

  @override
  void initState() {
    _formacionesDisponibles = getDropDownMenuItems();
    _formacionActual = _formacionesDisponibles[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String f in _formaciones) {
      items.add(new DropdownMenuItem(value: f, child: new Text(f)));
    }
    return items;
  }

  void cambiarFormacion(formacionElegida) {
    setState(() {
      _formacionActual = formacionElegida;
    });
  }
  void actualizarFormacionFavorita(String formacionElegida) async {
    cambiarFormacion(formacionElegida);
    final boxPerfil = Hive.box('perfil');
    Map<String, dynamic> equipo = {
      "nombre_equipo": "",
      "escudo": "",
      "modo_oscuro": false,
      "alineacion_favorita": [
        {'0': null, '1': null, '2': null, '3': null, '4': null, '5': null, '6': null, '7': null, '8': null, '9': null, '10': null},
        formacionElegida
      ]
    };
    if (boxPerfil.get(0) != null) {
      equipo = Map.from(boxPerfil.get(0));
      equipo["alineacion_favorita"][1] = formacionElegida;
    }
    boxPerfil.putAt(0, equipo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Hive.openBox('perfil'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else {
                final boxPerfil = Hive.box('perfil');
                Map<String, dynamic> equipo = {
                  "nombre_equipo": "",
                  "escudo": "",
                  "modo_oscuro": false,
                  "alineacion_favorita": [
                    {'0': null, '1': null, '2': null, '3': null, '4': null, '5': null, '6': null, '7': null, '8': null, '9': null, '10': null},
                    "14231"
                  ]
                };
                //Seleccionar formación inicial
                String formacionInicialFavorita = "14231";
                if (boxPerfil.get(0) != null) {
                  equipo = Map.from(boxPerfil.get(0));
                  formacionInicialFavorita = equipo["alineacion_favorita"][1];
                }
                //PONER VALOR INICIAL
                int _posicionFormacionInicial = _formaciones.indexOf(formacionInicialFavorita);
                _formacionActual = _formacionesDisponibles[_posicionFormacionInicial].value;
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DropdownButton(
                        value: _formacionActual,
                        items: _formacionesDisponibles,
                        onChanged: (val) async {
                          actualizarFormacionFavorita(val);
                          cambiarFormacion(val);
                          setState(() {});
                        },
                      ),
                      Formacion(formacion: formacionInicialFavorita),
                    ],
                  ),
                );
              }
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: LinearProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
