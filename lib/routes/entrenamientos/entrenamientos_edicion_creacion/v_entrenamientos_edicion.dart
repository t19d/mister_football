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

class EntrenamientosEdicion extends StatefulWidget {
  final Entrenamiento entrenamiento;
  final int posicion;

  EntrenamientosEdicion({Key key, @required this.entrenamiento, @required this.posicion}) : super(key: key);

  @override
  createState() => _EntrenamientosEdicion();
}

class _EntrenamientosEdicion extends State<EntrenamientosEdicion> {
  //Box jugadores
  Box boxEntrenamientos;

  String ejerciciosFuture;

  //Datos
  DateTime fechaHoraInicial = DateTime.now();
  String fecha = "";
  String hora = "";
  List<String> ejercicios;
  List<dynamic> listaJugadores; //[{"idJugador": "XXXX", "opinion":"No"}]
  final formKey = new GlobalKey<FormState>();

  //Validar formulario
  void validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      Entrenamiento e =
          Entrenamiento(fecha: fecha.trim(), hora: hora.trim(), ejercicios: ejercicios, jugadoresOpiniones: listaJugadores, anotaciones: "");

      await _openBox();
      final boxEntrenamientos = Hive.box('entrenamientos');
      final boxEventos = Hive.box('eventos');

      Eventos eventosActualesObjeto = boxEventos.get(0);
      //Eliminar evento
      eventosActualesObjeto.listaEventos.remove("${widget.entrenamiento.fecha}/${widget.entrenamiento.hora}");
      //Crear el nuevo evento
      eventosActualesObjeto.listaEventos["${fecha}/${hora}"] = ["Entrenamiento"];
      boxEventos.putAt(0, eventosActualesObjeto);
      print(eventosActualesObjeto.listaEventos);

      boxEntrenamientos.putAt(widget.posicion, e);

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
    fecha = widget.entrenamiento.fecha;
    hora = widget.entrenamiento.hora;
    ejercicios = widget.entrenamiento.ejercicios;
    listaJugadores = widget.entrenamiento.jugadoresOpiniones.toList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                    'Editar entrenamiento',
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.primario)),
                                  color: Colors.white70,
                                  disabledColor: MisterFootball.primarioLight2,
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.primario)),
                                  color: Colors.white70,
                                  disabledColor: MisterFootball.primarioLight2,
                                  disabledTextColor: Colors.white70,
                                  onPressed: () {
                                    //Seleccionar hora
                                    DatePicker.showTimePicker(context, showTitleActions: true, onConfirm: (time) {
                                      setState(() {
                                        hora = ((time.hour.toString().length == 1) ? "0${time.hour}" : "${time.hour}") +
                                            ":" +
                                            ((time.minute.toString().length == 1) ? "0${time.minute}" : "${time.minute}");
                                      });
                                    }, currentTime: DateTime(
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
                                //Ejercicios
                                Container(
                                  padding: EdgeInsets.only(
                                    top: (MediaQuery.of(context).size.width * 0.001),
                                    bottom: (MediaQuery.of(context).size.width * 0.05),
                                    left: (MediaQuery.of(context).size.width * 0.05),
                                    right: (MediaQuery.of(context).size.width * 0.05),
                                  ),
                                  decoration: BoxDecoration(
                                    color: MisterFootball.primarioLight2.withOpacity(.05),
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
                                              color: MisterFootball.primario,
                                            ),
                                            tooltip: 'Editar ejercicios',
                                            onPressed: () async {
                                              ejercicios = await showDialog<List<String>>(
                                                context: context,
                                                barrierDismissible: false,
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
                                    color: MisterFootball.primarioLight2.withOpacity(.05),
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
                                              color: MisterFootball.primario,
                                            ),
                                            tooltip: 'Editar jugadores',
                                            onPressed: () async {
                                              listaJugadores = await showDialog<List<dynamic>>(
                                                context: context,
                                                barrierDismissible: false,
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.primario)),
                            color: Colors.white70,
                            disabledColor: MisterFootball.primarioLight2,
                            disabledTextColor: Colors.white70,
                            child: Text("Editar"),
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
                      color: MisterFootball.semiprimario,
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
                      color: MisterFootball.semiprimario,
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
        child: Text("No hay ningún ejercicio añadido."),
      );
    }
  }

//Colorear ejercicios
/*Color colorearEjercicios(tipo) {
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
                          print("Añadido");
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
                      print("Añadido");
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.primario)),
              color: Colors.white70,
              disabledColor: MisterFootball.primarioLight2,
              disabledTextColor: Colors.white70,
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
        child: Text("No hay ningún jugador añadido."),
      );
    }
  }

//Mostrar lista seleccionable de jugadores
  Widget listaSeleccionarJugadores(List<dynamic> preListaJugadores, StateSetter setState) {
    List<dynamic> postListaJugadores = preListaJugadores; //{"idJugador": "XXXX", "opinion":"No"}
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
                          print("Añadido");
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
                      print("Añadido");
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.primario)),
              color: Colors.white70,
              disabledColor: MisterFootball.primarioLight2,
              disabledTextColor: Colors.white70,
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.pop(context, postListaJugadores);
              },
            )
          ],
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Text("Ningún jugador creado."),
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
                          print("Añadido");
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
