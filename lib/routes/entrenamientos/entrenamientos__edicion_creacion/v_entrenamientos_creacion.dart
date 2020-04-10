import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/database/DBHelper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mister_football/main.dart';

class EntrenamientosCreacion extends StatefulWidget {
  EntrenamientosCreacion({Key key}) : super(key: key);

  @override
  _EntrenamientosCreacion createState() => _EntrenamientosCreacion();
}

class _EntrenamientosCreacion extends State<EntrenamientosCreacion> {
  //Box jugadores
  Box boxEntrenamientos = null;

  //Datos
  String fecha = DateTime.now().toLocal().toString().split(' ')[0];
  String hora = "";
  List<int> ejercicios = [];
  final formKey = new GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  //Validar formulario
  validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Entrenamiento e = Entrenamiento(
          fecha: fecha.trim(),
          //hora: hora.trim(),
          hora: "19:30",
          //ejercicios: ejercicios,
          ejercicios: [],);

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
                          _selectDate(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fecha"),
                            Row(
                              children: <Widget>[
                                Text("${selectedDate.toLocal()}".split(' ')[0]),
                                Icon(Icons.calendar_today),
                              ],
                            ),
                          ],
                        ),
                      ),
                      separadorFormulario(),

                      //Hora
                      /*TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) =>
                        val.length == 0 ? 'Escribe el nombre' : null,
                        onChanged: (val) => hora = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Nombre del jugador',
                          labelText: 'Nombre',
                        ),
                      ),
                      separadorFormulario(),
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
                      ),
                      separadorFormulario(),
                      //Apellido2
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length == 0
                            ? 'Escribe el segundo apellido'
                            : null,
                        onChanged: (val) => apellido2 = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Segundo apellido del jugador',
                          labelText: 'Segundo apellido',
                        ),
                      ),
                      separadorFormulario(),
                      //Apodo
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) =>
                        val.length == 0 ? 'Escribe el apodo' : null,
                        onChanged: (val) => apodo = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Apodo del jugador',
                          labelText: 'Apodo',
                        ),
                      ),
                      ),*/
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
      height: 8.0,
    );
  }

  /*   */

  //Seleccionar fecha
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        fecha = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }
}
