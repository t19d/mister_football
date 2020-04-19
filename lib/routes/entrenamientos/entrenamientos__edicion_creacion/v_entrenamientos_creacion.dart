import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:hive/hive.dart';

class EntrenamientosCreacion extends StatefulWidget {
  EntrenamientosCreacion({Key key}) : super(key: key);

  @override
  _EntrenamientosCreacion createState() => _EntrenamientosCreacion();
}

class _EntrenamientosCreacion extends State<EntrenamientosCreacion> {
  //Box jugadores
  Box boxEntrenamientos = null;

  //Datos
  DateTime fechaHoraInicial = DateTime.now();
  String fecha = "";
  String hora = "";
  List<int> ejercicios = [];
  final formKey = new GlobalKey<FormState>();

  //Validar formulario
  validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Entrenamiento e = Entrenamiento(
        fecha: fecha.trim(),
        hora: hora.trim(),
        //ejercicios: ejercicios,
        ejercicios: [],
      );

      //Almacenar al jugador en la Box de 'entrenamientos'
      if (Hive.isBoxOpen('entrenamientos')) {
        boxEntrenamientos.add(e);
      } else {
        abrirBoxEntrenamentos();
        boxEntrenamientos.add(e);
      }
      Navigator.pop(context);
    }
  }

  void abrirBoxEntrenamentos() async {
    //Abrir box
    boxEntrenamientos = await Hive.openBox('entrenamientos');
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fecha =
        "${fechaHoraInicial.year}-${fechaHoraInicial.month}-${fechaHoraInicial.day}";
    hora = "${fechaHoraInicial.hour}:${fechaHoraInicial.minute}";
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      abrirBoxEntrenamentos();
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nuevo entrenamiento',
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 8),
                  child: Column(
                    children: <Widget>[
                      //Fecha
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar fecha
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1950, 1, 1),
                              maxTime: DateTime(2200, 12, 31),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar hora
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onConfirm: (time) {
                            setState(() {
                              hora = "${time.hour}:${time.minute}";
                            });
                          },
                              currentTime: DateTime.now(),
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
                      /*
                      //Ejercicios
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length == 0
                            ? 'Escribe el primer apellido'
                            : null,
                        onChanged: (val) => apellido1 = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Primer apellido del jugador',
                          labelText: 'Primer apellido',
                        ),
                      ),*/
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: Colors.red,
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    separadorFormulario(),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: Colors.lightGreen,
                      child: Text("Crear"),
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
      height: MediaQuery.of(context).size.width / 50,
      width: MediaQuery.of(context).size.width / 50,
    );
  }
}
