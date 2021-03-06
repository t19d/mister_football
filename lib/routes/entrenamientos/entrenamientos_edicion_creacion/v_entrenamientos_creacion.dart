import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/entrenamientos/v_entrenamientos.dart';
import 'package:reorderables/reorderables.dart';

class EntrenamientosCreacion extends StatefulWidget {
  EntrenamientosCreacion({Key key}) : super(key: key);

  @override
  _EntrenamientosCreacion createState() => _EntrenamientosCreacion();
}

class _EntrenamientosCreacion extends State<EntrenamientosCreacion> {
  //Box jugadores
  Box boxEntrenamientos;

  String ejerciciosFuture;

  //Datos
  DateTime fechaHoraInicial = DateTime.now();
  String fecha = "";
  String hora = "";
  List<String> ejercicios;
  List<Map<String, String>> listaJugadores; //[{"idJugador": "XXXX", "opinion":"No"}]
  final formKey = new GlobalKey<FormState>();

  //Validar formulario
  void validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      Entrenamiento e =
          Entrenamiento(fecha: fecha.trim(), hora: hora.trim(), ejercicios: ejercicios, jugadoresOpiniones: listaJugadores, anotaciones: "");

      //Almacenar al jugador en la Box de 'entrenamientos'
      /*if (Hive.isBoxOpen('entrenamientos')) {
        boxEntrenamientos.add(e);
      } else {
        abrirBoxEntrenamentos();
        boxEntrenamientos.add(e);
      }
      Navigator.pop(context);*/
      await _openBox();
      final boxEntrenamientos = Hive.box('entrenamientos');
      final boxEventos = Hive.box('eventos');
      boxEntrenamientos.add(e);
      Eventos eventosActualesObjeto = new Eventos(listaEventos: {});
      if (boxEventos.get(0) != null) {
        eventosActualesObjeto = boxEventos.get(0);
        eventosActualesObjeto.listaEventos["${fecha}/${hora}"] = ["Entrenamiento"];
        boxEventos.putAt(0, eventosActualesObjeto);
      } else {
        eventosActualesObjeto.listaEventos["${fecha}/${hora}"] = ["Entrenamiento"];
        boxEventos.add(eventosActualesObjeto);
      }
      print(eventosActualesObjeto.listaEventos);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Entrenamientos()),
      );
    }
  }

  Future<void> _openBox() async {
    await Hive.openBox("entrenamientos");
    await Hive.openBox("eventos");
    await Hive.openBox("jugadores");
    //Ejercicios del JSON
    ejerciciosFuture = await cargarEjercicios();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fecha = "${fechaHoraInicial.year}-" +
        ((fechaHoraInicial.month.toString().length == 1) ? "0${fechaHoraInicial.month}" : "${fechaHoraInicial.month}") +
        "-" +
        ((fechaHoraInicial.day.toString().length == 1) ? "0${fechaHoraInicial.day}" : "${fechaHoraInicial.day}");
    hora = ((fechaHoraInicial.hour.toString().length == 1) ? "0${fechaHoraInicial.hour}" : "${fechaHoraInicial.hour}") +
        ":" +
        ((fechaHoraInicial.minute.toString().length == 1) ? "0${fechaHoraInicial.minute}" : "${fechaHoraInicial.minute}");
    ejercicios = [];
    listaJugadores = [];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    /*return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nuevo entrenamiento',
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
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
                        //Ejercicios
                        Container(
                          padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
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
                                        builder: (BuildContext context) {
                                          /*return _DialogoSeleccionarEjercicios(
                                              ejerciciosDialogo: ejercicios,
                                              cargarEjerciciosDialogo:
                                                  cargarEjercicios);
                                        }*/
                                          return AlertDialog(content: StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                              //return Dialog(
                                              /*shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),*/
                                              return FutureBuilder(
                                                future: cargarEjercicios(),
                                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      print(snapshot.error.toString());
                                                      return Text(snapshot.error.toString());
                                                    } else {
                                                      return listaSeleccionarEjercicios(snapshot.data, ejercicios, setState);
                                                    }
                                                  } else {
                                                    return LinearProgressIndicator();
                                                  }
                                                },
                                              );
                                            },
                                          ));
                                          /*builder: (context, setState) {
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.0),
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
                                        );*/
                                        },
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              FutureBuilder(
                                future: cargarEjercicios(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error.toString());
                                      return Text(snapshot.error.toString());
                                    } else {
                                      return mostrarEjerciciosSeleccionados(snapshot.data, ejercicios);
                                    }
                                  } else {
                                    return LinearProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        separadorFormulario(),
                        //Jugadores
                        Container(
                          padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                          width: MediaQuery.of(context).size.width / 1.20,
                          color: Colors.grey.withOpacity(.15),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Jugadores"),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    tooltip: 'Editar jugadores',
                                    onPressed: () async {
                                      listaJugadores = await showDialog<List<dynamic>>(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(content: StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                              return FutureBuilder(
                                                future: Hive.openBox('jugadores'),
                                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      print(snapshot.error.toString());
                                                      return Container(
                                                        width: MediaQuery.of(context).size.width / 1,
                                                        height: MediaQuery.of(context).size.height / 1,
                                                        child: Text(snapshot.error.toString()),
                                                      );
                                                    } else {
                                                      return listaSeleccionarJugadores(listaJugadores, setState);
                                                    }
                                                  } else {
                                                    return Container(
                                                      width: MediaQuery.of(context).size.width / 1,
                                                      child: LinearProgressIndicator(),
                                                    );
                                                  }
                                                },
                                                /*future: Hive.openBox('jugadores'),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print(snapshot.error
                                                        .toString());
                                                    return Text(snapshot.error
                                                        .toString());
                                                  } else {
                                                    return listaSeleccionarJugadores(
                                                        listaJugadores,
                                                        setState);
                                                  }
                                                } else {
                                                  return LinearProgressIndicator();
                                                }
                                              },*/
                                              );
                                            },
                                          ));
                                        },
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              FutureBuilder(
                                future: Hive.openBox('jugadores'),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error.toString());
                                      return Container(
                                        width: MediaQuery.of(context).size.width / 1,
                                        height: MediaQuery.of(context).size.height / 1,
                                        child: Text(snapshot.error.toString()),
                                      );
                                    } else {
                                      return mostrarJugadoresSeleccionados(listaJugadores);
                                    }
                                  } else {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 1,
                                      height: MediaQuery.of(context).size.height / 1,
                                      child: LinearProgressIndicator(),
                                    );
                                  }
                                },
                                /*future: Hive.openBox('jugadores'),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error.toString());
                                    return Text(snapshot.error.toString());
                                  } else {
                                    return mostrarJugadoresSeleccionados(listaJugadores);
                                  }
                                } else {
                                  return LinearProgressIndicator();
                                }
                              },*/
                              ),
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
      ),
    );
    */
    return FutureBuilder(
      future: _openBox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            return SafeArea(
              key: _scaffoldKey,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Nuevo entrenamiento',
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 8),
                            child: Column(
                              children: <Widget>[
                                //Fecha
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
                                  color: Colors.white70,
                                  disabledColor: MisterFootball.colorPrimarioLight2,
                                  disabledTextColor: Colors.white70,
                                  onPressed: () {
                                    //Seleccionar fecha
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true, minTime: DateTime(1950, 1, 1), maxTime: DateTime(2200, 12, 31), onConfirm: (date) {
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
                                  color: Colors.white70,
                                  disabledColor: MisterFootball.colorPrimarioLight2,
                                  disabledTextColor: Colors.white70,
                                  onPressed: () {
                                    //Seleccionar hora
                                    DatePicker.showTimePicker(context, showTitleActions: true, onConfirm: (time) {
                                      setState(() {
                                        hora = ((time.hour.toString().length == 1) ? "0${time.hour}" : "${time.hour}") +
                                            ":" +
                                            ((time.minute.toString().length == 1) ? "0${time.minute}" : "${time.minute}");
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
                                //Ejercicios
                                Container(
                                  padding: EdgeInsets.only(
                                    top: (MediaQuery.of(context).size.width * 0.001),
                                    bottom: (MediaQuery.of(context).size.width * 0.05),
                                    left: (MediaQuery.of(context).size.width * 0.05),
                                    right: (MediaQuery.of(context).size.width * 0.05),
                                  ),
                                  decoration: BoxDecoration(
                                    color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
                                    border: Border(
                                      top: BorderSide(width: .4),
                                      bottom: BorderSide(width: .4),
                                      left: BorderSide(width: .4),
                                      right: BorderSide(width: .4),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.20,
                                  //height: (ejercicios.length * 180).toDouble(),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Ejercicios",
                                            style: TextStyle(decoration: TextDecoration.underline),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: MisterFootball.colorPrimario,
                                            ),
                                            tooltip: 'Editar ejercicios',
                                            onPressed: () async {
                                              await showDialog<List<String>>(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setState) {
                                                        return listaSeleccionarEjercicios(ejerciciosFuture, ejercicios, setState);
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                      mostrarEjerciciosSeleccionados(ejerciciosFuture, ejercicios),
                                    ],
                                  ),
                                ),
                                separadorFormulario(),
                                //Jugadores
                                Container(
                                  padding: EdgeInsets.only(
                                    top: (MediaQuery.of(context).size.width * 0.001),
                                    bottom: (MediaQuery.of(context).size.width * 0.05),
                                    left: (MediaQuery.of(context).size.width * 0.05),
                                    right: (MediaQuery.of(context).size.width * 0.05),
                                  ),
                                  decoration: BoxDecoration(
                                    color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
                                    border: Border(
                                      top: BorderSide(width: .4),
                                      bottom: BorderSide(width: .4),
                                      left: BorderSide(width: .4),
                                      right: BorderSide(width: .4),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.20,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Jugadores (${listaJugadores.length})",
                                            style: TextStyle(decoration: TextDecoration.underline),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: MisterFootball.colorPrimario,
                                            ),
                                            tooltip: 'Editar jugadores',
                                            onPressed: () async {
                                              await showDialog<List<dynamic>>(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setState) {
                                                        return listaSeleccionarJugadores(listaJugadores, setState);
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                      mostrarJugadoresSeleccionados(listaJugadores),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
                            color: Colors.white70,
                            disabledColor: MisterFootball.colorPrimarioLight2,
                            disabledTextColor: Colors.white70,
                            child: Text("Crear"),
                            onPressed: () async {
                              validar();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /*   */

  //Widget que separa los elementos del formulario
  Widget separadorFormulario() {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 50,
      width: MediaQuery.of(context).size.width / 50,
    );
  }

  /* Ejercicios */
  Widget mostrarEjerciciosSeleccionados(String ejerciciosString, List<String> ejercicios) {
    List<dynamic> listaEjerciciosJSON = jsonDecode(ejerciciosString);
    if (ejercicios.length > 0) {
      return ReorderableColumn(
          scrollController: ScrollController(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            ejercicios.length,
            (iEjercicio) {
              //return Text("${iEjercicio + 1}-${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}");
              /*return ListTile(
                key: Key("$iEjercicio"),
                title: Text("${iEjercicio + 1}-${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}"),
              );*/
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: .4),
                    bottom: BorderSide(width: .4),
                    left: BorderSide(width: .4),
                    right: BorderSide(width: .4),
                  ),
                ),
                margin: EdgeInsets.only(
                  top: (iEjercicio != 0) ? 2.5 : 0,
                  bottom: (iEjercicio != (ejercicios.length - 1)) ? 2.5 : 0,
                  right: 0,
                  left: 0,
                ),
                key: Key("$iEjercicio"),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width * .63),
                      padding: EdgeInsets.all((MediaQuery.of(context).size.width * 0.025)),
                      child: Text(
                        "${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}",
                      ),
                    ),
                    Icon(
                      Icons.unfold_more,
                      color: MisterFootball.colorSemiprimario,
                    ),
                  ],
                ),
              );
            },
          ),
          onReorder:
              /*(oldIndex, newIndex) {
          String old = ejercicios[oldIndex];
          if (oldIndex > newIndex) {
            for (int i = oldIndex; i > newIndex; i--) {
              ejercicios[i] = ejercicios[i - 1];
            }
            ejercicios[newIndex] = old;
          } else {
            for (int i = oldIndex; i < newIndex - 1; i++) {
              ejercicios[i] = ejercicios[i + 1];
            }
            ejercicios[newIndex - 1] = old;
          }
          setState(() {});
        },*/
              (int oldIndex, int newIndex) {
            setState(() {
              String row = ejercicios.removeAt(oldIndex);
              ejercicios.insert(newIndex, row);
            });
          });
      /*return ReorderableListView(
          //padding: EdgeInsets.symmetric(horizontal: 40),
          children: List.generate(
            ejercicios.length,
            (iEjercicio) {
              //return Text("${iEjercicio + 1}-${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}");
              /*return ListTile(
                key: Key("$iEjercicio"),
                title: Text("${iEjercicio + 1}-${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}"),
              );*/
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: .4),
                    bottom: BorderSide(width: .4),
                    left: BorderSide(width: .4),
                    right: BorderSide(width: .4),
                  ),
                ),
                margin: EdgeInsets.only(
                  top: (iEjercicio != 0) ? 2.5 : 0,
                  bottom: (iEjercicio != (ejercicios.length - 1)) ? 2.5 : 0,
                  right: 0,
                  left: 0,
                ),
                key: Key("$iEjercicio"),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width * .63),
                      padding: EdgeInsets.all((MediaQuery.of(context).size.width * 0.025)),
                      child: Text(
                        "${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}",
                      ),
                    ),
                    Icon(
                      Icons.unfold_more,
                      color: MisterFootball.colorSemiprimario,
                    ),
                  ],
                ),
              );
            },
          ),
          onReorder: (oldIndex, newIndex) {
            String old = ejercicios[oldIndex];
            if (oldIndex > newIndex) {
              for (int i = oldIndex; i > newIndex; i--) {
                ejercicios[i] = ejercicios[i - 1];
              }
              ejercicios[newIndex] = old;
            } else {
              for (int i = oldIndex; i < newIndex - 1; i++) {
                ejercicios[i] = ejercicios[i + 1];
              }
              ejercicios[newIndex - 1] = old;
            }
            setState(() {});
          },
      );*/
    } else {
      return Center(
        child: Text("No hay ning??n ejercicio a??adido."),
      );
    }
  }

//Colorear ejercicios
/*Color colorearEjercicios(tipo) {
    Color coloreado = Colors.white;
    switch (tipo) {
      case "F??sico":
        coloreado = Colors.orange;
        break;
      case "T??ctico":
        coloreado = Colors.lightBlue;
        break;
      case "T??cnico":
        coloreado = Colors.red;
        break;
    }
    return coloreado.withOpacity(.7);
  }*/

//Cargar lista de ejercicios desde JSON
  Future<String> cargarEjercicios() async {
    return await rootBundle.loadString('assets/json/ejercicios.json');
  }

//Mostrar lista seleccionable de ejercicios JSON
  Widget listaSeleccionarEjercicios(String ejerciciosString, List<String> ejecicios, StateSetter setState) {
    List<String> ejerciciosSeleccionados = ejecicios;
    print(ejerciciosSeleccionados);
    List<dynamic> listaEjerciciosJSON = jsonDecode(ejerciciosString);
    if (listaEjerciciosJSON.length > 0) {
      return Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Column(
          children: <Widget>[
            Text("Modificar ejercicios"),
            ListView(
              shrinkWrap: true,
              children: List.generate(listaEjerciciosJSON.length, (iEjercicio) {
                bool _isSeleccionado = (ejerciciosSeleccionados.contains("${listaEjerciciosJSON[iEjercicio]['id']}")) ? true : false;
                /*return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("-${listaEjerciciosJSON[iEjercicio]['titulo']}"),
                    ),
                    Checkbox(
                      value: _isSeleccionado,
                      onChanged: (bool nuevoEstado) {
                        setState(() {
                          _isSeleccionado = nuevoEstado;
                        });
                        if (_isSeleccionado) {
                          print("A??adido");
                          setState(() {
                            ejerciciosSeleccionados.add("${listaEjerciciosJSON[iEjercicio]['id']}");
                          });
                          print(ejerciciosSeleccionados);
                        } else {
                          print("Eliminado");
                          setState(() {
                            ejerciciosSeleccionados.removeWhere((id) => id == "${listaEjerciciosJSON[iEjercicio]['id']}");
                          });
                          print(ejerciciosSeleccionados);
                        }
                      },
                    ),
                  ],
                );
              */
                return CheckboxListTile(
                  title: Text("-${listaEjerciciosJSON[iEjercicio]['titulo']}"),
                  value: _isSeleccionado,
                  onChanged: (bool nuevoEstado) {
                    setState(() {
                      _isSeleccionado = nuevoEstado;
                    });
                    if (_isSeleccionado) {
                      print("A??adido");
                      setState(() {
                        ejerciciosSeleccionados.add("${listaEjerciciosJSON[iEjercicio]['id']}");
                      });
                      print(ejerciciosSeleccionados);
                    } else {
                      print("Eliminado");
                      setState(() {
                        ejerciciosSeleccionados.removeWhere((id) => id == "${listaEjerciciosJSON[iEjercicio]['id']}");
                      });
                      print(ejerciciosSeleccionados);
                    }
                  },
                );
              }),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
              color: Colors.white70,
              disabledColor: MisterFootball.colorPrimarioLight2,
              disabledTextColor: Colors.white70,
              child: Text("Aceptar"),
              onPressed: () {
                ejercicios = ejerciciosSeleccionados;
                Navigator.pop(context, ejerciciosSeleccionados);
              },
            )
          ],
        ),
      );
    }
  }

/* Jugadores */

  Widget mostrarJugadoresSeleccionados(List<dynamic> jugadoresElegidos) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (jugadoresElegidos.length > 0) {
      return ListView(
        //No Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(jugadoresElegidos.length, (iFila) {
          Jugador jugadorFila;
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (jugadoresElegidos[iFila]['idJugador'] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
            }
          }
          return Text("-${jugadorFila.apodo}");
        }),
      );
    } else {
      return Center(
        child: Text("No hay ning??n jugador a??adido."),
      );
    }
  }

//Mostrar lista seleccionable de jugadores
  Widget listaSeleccionarJugadores(List<dynamic> preListaJugadores, StateSetter setState) {
    List<Map<String, String>> postListaJugadores = preListaJugadores; //{"idJugador": "XXXX", "opinion":"No"}
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Column(
          children: <Widget>[
            Text("Modificar jugadores"),
            ListView(
              shrinkWrap: true,
              children: List.generate(boxJugadores.length, (iJugador) {
                final Jugador jugadorBox = boxJugadores.getAt(iJugador) as Jugador;
                //bool _isSeleccionado = (postListaJugadores.contains(jugadorBox.id)) ? true : false;
                bool _isSeleccionado = false;
                for (var i = 0; i < postListaJugadores.length; i++) {
                  if (jugadorBox.id == postListaJugadores[i]["idJugador"]) {
                    _isSeleccionado = true;
                  }
                }
                /*return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("-${jugadorBox.nombre}"),
                    ),
                    Checkbox(
                      value: _isSeleccionado,
                      onChanged: (bool nuevoEstado) {
                        setState(() {
                          _isSeleccionado = nuevoEstado;
                        });
                        if (_isSeleccionado) {
                          print("A??adido");
                          setState(() {
                            postListaJugadores.add({"idJugador": "${jugadorBox.id}", "opinion": ""});
                          });
                          print(postListaJugadores);
                        } else {
                          print("Eliminado");
                          setState(() {
                            postListaJugadores.removeWhere((fila) => fila["idJugador"] == jugadorBox.id);
                          });
                          print(postListaJugadores);
                        }
                      },
                    ),
                  ],
                );
              */
                return CheckboxListTile(
                  title: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: <Widget>[
                          ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                          Text("${jugadorBox.apodo}"), //, style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04)),
                          //Text("${jugadorBox.posicionFavorita}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05),),
                        ],
                      ),
                    ],
                  ),
                  value: _isSeleccionado,
                  onChanged: (bool nuevoEstado) {
                    setState(() {
                      _isSeleccionado = nuevoEstado;
                    });
                    if (_isSeleccionado) {
                      print("A??adido");
                      setState(() {
                        postListaJugadores.add({"idJugador": "${jugadorBox.id}", "opinion": ""});
                      });
                      print(postListaJugadores);
                    } else {
                      print("Eliminado");
                      setState(() {
                        postListaJugadores.removeWhere((fila) => fila["idJugador"] == jugadorBox.id);
                      });
                      print(postListaJugadores);
                    }
                  },
                );
              }),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
              color: Colors.white70,
              disabledColor: MisterFootball.colorPrimarioLight2,
              disabledTextColor: Colors.white70,
              child: Text("Aceptar"),
              onPressed: () {
                listaJugadores = postListaJugadores;
                Navigator.pop(context, postListaJugadores);
              },
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Text("Ning??n jugador creado."),
      );
    }
  }
}

//Pruebas
/*
class _DialogoSeleccionarEjercicios extends StatefulWidget {
  _DialogoSeleccionarEjercicios({
    this.ejerciciosDialogo,
    this.cargarEjerciciosDialogo,
  });

  final List<String> ejerciciosDialogo;
  final Function cargarEjerciciosDialogo;

  @override
  _DialogoSeleccionarEjerciciosState createState() =>
      _DialogoSeleccionarEjerciciosState();
}

class _DialogoSeleccionarEjerciciosState
    extends State<_DialogoSeleccionarEjercicios> {

  @override
  void initState() {
    super.initState();
  }


//Mostrar lista seleccionable de ejercicios JSON
  listaSeleccionarEjercicios(String ejerciciosString, List<String> ejecicios) {
    List<String> ejerciciosSeleccionados = ejecicios;
    print(ejerciciosSeleccionados);
    List<dynamic> listaEjerciciosJSON = jsonDecode(ejerciciosString);
    if (listaEjerciciosJSON.length > 0) {
      return Container(
        /*width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,*/
        child: Column(
          children: <Widget>[
            Text("Modificar ejercicios"),
            ListView(
              shrinkWrap: true,
              children: List.generate(listaEjerciciosJSON.length, (iEjercicio) {
                bool _isSeleccionado = (ejerciciosSeleccionados
                    .contains("${listaEjerciciosJSON[iEjercicio]['id']}"))
                    ? true
                    : false;
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
                          print("A??adido");
                          setState(() {
                            ejerciciosSeleccionados.add(
                                "${listaEjerciciosJSON[iEjercicio]['id']}");
                          });
                          print(ejerciciosSeleccionados);
                        } else {
                          print("Eliminado");
                          setState(() {
                            ejerciciosSeleccionados.removeWhere((id) =>
                            id ==
                                "${listaEjerciciosJSON[iEjercicio]['id']}");
                          });
                          print(ejerciciosSeleccionados);
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
            RaisedButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.pop(context, ejerciciosSeleccionados);
              },
            )
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: widget.cargarEjerciciosDialogo(),
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
                  snapshot.data, widget.ejerciciosDialogo);
            }
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
*/
