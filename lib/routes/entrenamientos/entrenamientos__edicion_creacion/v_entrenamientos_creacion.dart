import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/routes/ejercicios/ejercicio/v_detalles_ejercicio_json.dart';

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
  List<String> ejercicios = [];
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
                      //Ejercicios
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            (MediaQuery.of(context).size.width * 0.05),
                            0,
                            0,
                            0),
                        width: MediaQuery.of(context).size.width / 1.20,
                        color: Colors.grey.withOpacity(.15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Ejercicios"),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  tooltip: 'Editar ejercicios',
                                  onPressed: () async {
                                    ejercicios = await showDialog<List<String>>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: FutureBuilder(
                                          future: cargarEjercicios(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasError) {
                                                print(
                                                    snapshot.error.toString());
                                                return Text(
                                                    snapshot.error.toString());
                                              } else {
                                                return listaSeleccionarEjercicios(
                                                    snapshot.data, ejercicios);
                                              }
                                            } else {
                                              return LinearProgressIndicator();
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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

  /* Ejercicios */
  //Colorear ejercicios
  Color colorearEjercicios(tipo) {
    Color coloreado = Colors.white;
    switch (tipo) {
      case "Físico":
        coloreado = Colors.orange;
        break;
      case "Táctico":
        coloreado = Colors.lightBlue;
        break;
      case "Técnico":
        coloreado = Colors.red;
        break;
    }
    return coloreado.withOpacity(.7);
  }

  //Cargar lista de ejercicios desde JSON
  Future<String> cargarEjercicios() async {
    return await rootBundle.loadString('assets/json/ejercicios.json');
  }

  //Mostrar lista seleccionable de ejercicios JSON
  listaSeleccionarEjercicios(String ejerciciosString, List<String> ejecicios) {
    List<String> ejerciciosSeleccionados = ejecicios;
    List<dynamic> listaEjerciciosJSON = jsonDecode(ejerciciosString);
    if (listaEjerciciosJSON.length > 0) {
      return Container(
        /*width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,*/

        child: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: List.generate(listaEjerciciosJSON.length, (iEjercicio) {
                bool _isSeleccionado = false;
                return Row(
                  children: <Widget>[
                    Expanded(
                    child: Text(listaEjerciciosJSON[iEjercicio]['titulo']),
                  ),
                    Checkbox(
                      value: _isSeleccionado,
                      onChanged: (bool nuevoEstado) {
                        setState(() {
                          _isSeleccionado = nuevoEstado;
                        });
                        if (_isSeleccionado) {
                          print(listaEjerciciosJSON[iEjercicio]['id']);
                          ejerciciosSeleccionados.add(listaEjerciciosJSON[iEjercicio]['id']);
                        } else {
                          ejerciciosSeleccionados.removeWhere((id) =>
                              id == listaEjerciciosJSON[iEjercicio]['id']);
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      );
      /*return Card(
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),*/
            child: new InkWell(
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetallesEjercicioJSON(
                            datos: ejercicios[iEjercicio],
                          )),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorearEjercicios(ejercicios[iEjercicio]['tipo']),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Título
                    Text(
                      ejercicios[iEjercicio]['titulo'],
                      textAlign: TextAlign.center,
                    ),
                    //Tipo
                    Text(
                      ejercicios[iEjercicio]['tipo'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    //Tiempo
                    Text(
                      ejercicios[iEjercicio]['duracion'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    //Dificultad
                    Text(
                      ejercicios[iEjercicio]['dificultad'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              //),
            ),
          );*/
    }
  }

/* Jugadores */
/*cartasJugadores() {
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return ListView(
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(iJugador) as Jugador;
          return Card(
            child: new InkWell(
              splashColor: Colors.lightGreen,
              onTap: () {
                Navigator.pop(context, jugadorBox);
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetallesJugador(posicion: iJugador,),
                  ),
                );
              },
              child: Container(
                color: colorear(jugadorBox.posicionFavorita),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ConversorImagen.imageFromBase64String(
                        jugadorBox.nombre_foto, context),
                    Column(
                      children: <Widget>[
                        Text(
                          jugadorBox.apodo,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          jugadorBox.posicionFavorita,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún jugador creado."),
      );
    }
  }*/
}
