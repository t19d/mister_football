import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';

class PartidosCreacion extends StatefulWidget {
  PartidosCreacion({Key key}) : super(key: key);

  @override
  _PartidosCreacion createState() => _PartidosCreacion();
}

class _PartidosCreacion extends State<PartidosCreacion> {
  //Box partidos
  Box boxPartidos = null;

  //Datos
  DateTime fechaHoraInicial = DateTime.now();
  String fecha = "";
  String hora = "";
  String lugar = "";
  String rival = "";
  String tipoPartido = "";
  final formKey = new GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _tipoDePartidoDisponibles;
  List _tipoDePartido = ["Liga", "Copa", "Amistoso", "Torneo amistoso"];

  //Validar formulario
  validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Partido p = Partido(fecha: fecha.trim(), hora: hora.trim(), lugar: lugar.trim(), rival: rival.trim(), tipoPartido: tipoPartido.trim());

      //Almacenar el partido en la Box de 'partidos'
      if (Hive.isBoxOpen('partidos')) {
        boxPartidos.add(p);
      } else {
        abrirBoxPartidos();
        boxPartidos.add(p);
      }
      Navigator.pop(context);
    }
  }

  void abrirBoxPartidos() async {
    //Abrir box
    boxPartidos = await Hive.openBox('partidos');
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    fecha = "${fechaHoraInicial.year}-${fechaHoraInicial.month}-${fechaHoraInicial.day}";
    hora = "${fechaHoraInicial.hour}:${fechaHoraInicial.minute}";
    _tipoDePartidoDisponibles = getDropDownMenuItems();
    tipoPartido = _tipoDePartidoDisponibles[0].value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      abrirBoxPartidos();
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nuevo partido',
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 8),
                  child: Column(
                    children: <Widget>[
                      //Fecha
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar fecha
                          DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(1950, 1, 1), maxTime: DateTime(2200, 12, 31),
                              onConfirm: (date) {
                                setState(() {
                                  fecha = "${date.year}-${date.month}-${date.day}";
                                });
                              },
                              currentTime: DateTime(
                                int.parse(fecha.split("-")[0]),
                                int.parse(fecha.split("-")[1]),
                                int.parse(fecha.split("-")[2]),
                              ),
                              locale: LocaleType.es);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fecha"),
                            Row(
                              children: <Widget>[
                                Text("${fecha}"),
                                Icon(Icons.calendar_today),
                              ],
                            ),
                          ],
                        ),
                      ),
                      separadorFormulario(),
                      //Hora
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar hora
                          DatePicker.showTimePicker(context, showTitleActions: true, onConfirm: (time) {
                            setState(() {
                              hora = "${time.hour}:${time.minute}";
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.es);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Hora"),
                            Row(
                              children: <Widget>[
                                Text("${hora}"),
                                Icon(Icons.watch_later),
                              ],
                            ),
                          ],
                        ),
                      ),
                      separadorFormulario(),
                      //Rival
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length == 0 ? 'Escribe el equipo rival' : null,
                        onChanged: (val) => rival = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Equipo rival',
                          labelText: 'Equipo rival',
                        ),
                      ),
                      separadorFormulario(),
                      //Lugar
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length == 0 ? 'Escribe el lugar' : null,
                        onChanged: (val) => lugar = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Lugar del partido',
                          labelText: 'Lugar',
                        ),
                      ),
                      separadorFormulario(),
                      //Tipo partido
                      Column(
                        children: <Widget>[
                          Text("Tipo de partido"),
                          DropdownButton(
                            elevation: 2,
                            iconSize: 40.0,
                            value: tipoPartido,
                            items: _tipoDePartidoDisponibles,
                            onChanged: cambiarTipoDePartido,
                          ),
                        ],
                      ),
                      separadorFormulario(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Colors.red,
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Colors.lightBlueAccent,
                      child: Text("Crear jugador"),
                      onPressed: () async {
                        validar();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*   */

  //Widget que separa los elementos del formulario
  separadorFormulario() {
    return SizedBox(
      height: 8.0,
    );
  }

  /* POSICIONES */

  //Hacer el Spinner de tipo de partido
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String tp in _tipoDePartido) {
      items.add(new DropdownMenuItem(value: tp, child: new Text(tp)));
    }
    return items;
  }

  //Actualizar la posición cuando eliges en el Spinner
  cambiarTipoDePartido(tipoPartidoElegido) {
    setState(() {
      tipoPartido = tipoPartidoElegido;
    });
  }
}
