import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/v_partidos.dart';

class PartidosCreacion extends StatefulWidget {
  PartidosCreacion({Key key}) : super(key: key);

  @override
  _PartidosCreacion createState() => _PartidosCreacion();
}

class _PartidosCreacion extends State<PartidosCreacion> {
  //Box partidos
  Box boxPartidos;

  //Box eventos
  Box boxEventos;

  //Datos
  DateTime fechaHoraInicial = DateTime.now();
  String fecha = "";
  String hora = "";
  String lugar = "";
  String rival = "";
  String tipoPartido = "";
  bool isLocal = true;
  List<bool> _isSelected = [true, false];
  final formKey = new GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _tipoDePartidoDisponibles;
  List _tipoDePartido = ["Liga", "Copa", "Amistoso", "Torneo amistoso"];

  //Validar formulario
  void validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Map<String, Jugador> alineacionVacia = {
        '0': null,
        '1': null,
        '2': null,
        '3': null,
        '4': null,
        '5': null,
        '6': null,
        '7': null,
        '8': null,
        '9': null,
        '10': null
      };
      Partido p = Partido(
          fecha: fecha.trim(),
          hora: hora.trim(),
          lugar: lugar.trim(),
          rival: rival.trim(),
          tipoPartido: tipoPartido.trim(),
          convocatoria: [],
          alineacion: {
            '0': ["14231", alineacionVacia]
          },
          golesAFavor: [],
          golesEnContra: [],
          lesiones: [],
          tarjetas: [],
          cambios: [],
          observaciones: "",
          isLocal: isLocal);

      await _openBox();
      final boxPartidos = Hive.box('partidos');
      final boxEventos = Hive.box('eventos');
      boxPartidos.add(p);
      Eventos eventosActualesObjeto = new Eventos(listaEventos: {});
      if (boxEventos.get(0) != null) {
        eventosActualesObjeto = boxEventos.get(0);
      }
      eventosActualesObjeto.listaEventos["${fecha}/${hora}"] = ["Partido", rival, tipoPartido];
      boxEventos.put(0, eventosActualesObjeto);
      print(eventosActualesObjeto.listaEventos);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Partidos()),
      );
    }
  }

  Future<void> _openBox() async {
    await Hive.openBox("partidos");
    await Hive.openBox("eventos");
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    fecha = "${fechaHoraInicial.year}-" +
        ((fechaHoraInicial.month.toString().length == 1) ? "0${fechaHoraInicial.month}" : "${fechaHoraInicial.month}") +
        "-" +
        ((fechaHoraInicial.day.toString().length == 1) ? "0${fechaHoraInicial.day}" : "${fechaHoraInicial.day}");
    hora = ((fechaHoraInicial.hour.toString().length == 1) ? "0${fechaHoraInicial.hour}" : "${fechaHoraInicial.hour}") +
        ":" +
        ((fechaHoraInicial.minute.toString().length == 1) ? "0${fechaHoraInicial.minute}" : "${fechaHoraInicial.minute}");
    lugar = "";
    _tipoDePartidoDisponibles = getDropDownMenuItems();
    tipoPartido = _tipoDePartidoDisponibles[0].value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nuevo partido',
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              tooltip: 'Cancelar',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
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
                      //Rival
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (val) => val.length == 0 ? 'Escribe el equipo rival' : null,
                        onChanged: (val) => rival = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Equipo rival*',
                          labelText: 'Equipo rival*',
                        ),
                      ),
                      separadorFormulario(),
                      //Fecha
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar fecha
                          DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(1950, 1, 1), maxTime: DateTime(2200, 12, 31),
                              onConfirm: (date) {
                            setState(() {
                              fecha = "${date.year}-" +
                                  ((date.month.toString().length == 1) ? "0${date.month}" : "${date.month}") +
                                  "-" +
                                  ((date.day.toString().length == 1) ? "0${date.day}" : "${date.day}");
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
                                Text("${fecha.split("-")[2]}-${fecha.split("-")[1]}-${fecha.split("-")[0]}"),
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
                              hora = ((time.hour.toString().length == 1) ? "0${time.hour}" : "${time.hour}") +
                                  ":" +
                                  ((time.minute.toString().length == 1) ? "0${time.minute}" : "${time.minute}");
                            });
                          },
                              currentTime: DateTime(
                                int.parse(fecha.split("-")[0]),
                                int.parse(fecha.split("-")[1]),
                                int.parse(fecha.split("-")[2]),
                                int.parse(hora.split(":")[0]),
                                int.parse(hora.split(":")[1]),
                              ),
                              locale: LocaleType.es);
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
                      //Lugar
                      TextFormField(
                        initialValue: "",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        /*validator: (val) => val.length == 0 ? 'Escribe el lugar' : null,*/
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
                      //Local/Visitante
                      Column(
                        children: <Widget>[
                          ToggleButtons(
                            borderColor: Colors.blueAccent.withOpacity(.5),
                            selectedBorderColor: Colors.blueAccent,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.home,
                                      ),
                                      new Text(
                                        "LOCAL",
                                      )
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.directions_bus,
                                    ),
                                    Text(
                                      "VISITANTE",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _isSelected.length; i++) {
                                  if (i == index) {
                                    //Roja
                                    _isSelected[i] = true;
                                    isLocal = false;
                                  } else {
                                    //Amarilla
                                    _isSelected[i] = false;
                                    isLocal = true;
                                  }
                                }
                              });
                            },
                            isSelected: _isSelected,
                          ),
                        ],
                      ),
                      separadorFormulario(),
                      //Tipo partido
                      Column(
                        children: <Widget>[
                          Text("Tipo de partido"),
                          DropdownButton(
                            elevation: 2,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: MediaQuery.of(context).size.width * .07,
                            ),
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
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.lightGreenAccent,
                  child: Text("CREAR"),
                  onPressed: () async {
                    validar();
                  },
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
  Widget separadorFormulario() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .02,
    );
  }

  /* POSICIONES */

  //Hacer el Spinner de tipo de partido
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String tp in _tipoDePartido) {
      items.add(
        DropdownMenuItem(
          value: tp,
          child: Text(tp),
        ),
      );
    }
    return items;
  }

  //Actualizar la posición cuando eliges en el Spinner
  void cambiarTipoDePartido(tipoPartidoElegido) {
    setState(() {
      tipoPartido = tipoPartidoElegido;
    });
  }
}
