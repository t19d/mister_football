import 'package:flutter/material.dart';
import 'package:mister_football/routes/alineacion_favorita/w_formaciones.dart';

class CampoJugadores extends StatefulWidget {
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

  Widget alineacion(int formacion) {
    switch (formacion) {
      case 1442:
        columnas = 5;
        filas = (4 * columnas);
        break;
      case 1532:
        columnas = 7;
        filas = (4 * columnas);
        break;
    }

    return GridView.count(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: columnas,
      children: List.generate(filas, (index) {
        return Card(
          child: new InkWell(
            onTap: () {
              print("futuro");
            },
            focusColor: Colors.green,
            child: Text("$index"),
          ),
        );
      }),
    );
  }

  cambiarFormacion(formacionElegida) {
    setState(() {
      _formacionActual = formacionElegida;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: _formacionActual,
              items: _formacionesDisponibles,
              onChanged: cambiarFormacion,
            ),
            Formacion(
              formacion: _formacionActual,
            ),
          ],
        ),
      ),
    ));
  }
}
