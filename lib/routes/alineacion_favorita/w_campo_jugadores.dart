import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/routes/alineacion_favorita/v_alineacion.dart';
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
    _formacionActual = formacionElegida;
    //setState(() {});
  }

  void actualizarFormacionFavorita(String formacionElegida) async {
    Map<String, dynamic> equipo = Alineacion.equipoEditado;
    equipo["alineacion_favorita"][1] = formacionElegida;
    Alineacion.equipoEditado = equipo;
    cambiarFormacion(formacionElegida);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> equipo = Alineacion.equipoEditado;
    //Seleccionar formación inicial
    String formacionInicialFavorita = equipo["alineacion_favorita"][1];

    //PONER VALOR INICIAL
    int _posicionFormacionInicial = _formaciones.indexOf(formacionInicialFavorita);
    _formacionActual = _formacionesDisponibles[_posicionFormacionInicial].value;
    return Column(
      children: <Widget>[
        DropdownButton(
          value: _formacionActual,
          items: _formacionesDisponibles,
          onChanged: (val) async {
            actualizarFormacionFavorita(val);
            setState(() {});
          },
        ),
        Formacion(formacion: formacionInicialFavorita),
      ],
    );
  }
}
