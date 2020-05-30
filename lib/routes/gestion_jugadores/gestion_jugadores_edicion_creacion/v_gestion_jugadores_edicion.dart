import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/v_gestion_jugadores.dart';

class GestionJugadoresEdicion extends StatefulWidget {
  final Jugador jugador;
  final int posicion;

  GestionJugadoresEdicion({Key key, @required this.jugador, @required this.posicion}) : super(key: key);

  @override
  _GestionJugadoresEdicion createState() => _GestionJugadoresEdicion();
}

class _GestionJugadoresEdicion extends State<GestionJugadoresEdicion> {
  //Box jugadores
  Box boxJugadores;

  //Datos
  String nombre = "";
  String apellido1 = "";
  String apellido2 = "";
  String apodo = ""; //Opcional. En caso de estar vacío, se pone el apellido1
  String fechaNacimiento = DateTime.now().toLocal().toString().split(' ')[0];
  bool piernaDerechaBuena = true;
  String posicionFavorita = "";
  String anotaciones = "";
  String imgString = "";
  final formKey = new GlobalKey<FormState>();
  List<bool> _isSelected;
  List<DropdownMenuItem<String>> _posicionesDisponibles;
  List _posiciones = [
    "Portero",
    "Central",
    "Líbero",
    "Lateral derecho",
    "Lateral izquierdo",
    "Carrilero derecho",
    "Carrilero izquierdo",
    "Mediocentro defensivo",
    "Mediocentro central",
    "Mediocentro ofensivo",
    "Interior derecho",
    "Interior izquierdo",
    "Mediapunta",
    "Falso 9",
    "Segundo delantero",
    "Delantero centro",
    "Extremo derecho",
    "Extremo izquierdo"
  ];

  //Validar formulario
  void validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Jugador j = Jugador(
          nombre_foto: imgString,
          nombre: nombre.trim(),
          apellido1: apellido1.trim(),
          apellido2: apellido2.trim(),
          apodo: (apodo.trim() != "") ? apodo.trim() : apellido1,
          anotaciones: anotaciones.trim(),
          posicionFavorita: posicionFavorita.trim(),
          piernaBuena: (piernaDerechaBuena ? "Derecha" : "Izquierda"),
          fechaNacimiento: fechaNacimiento.trim(),
          id: widget.jugador.id,
          //Se dehabilitará en el momento en el que quiera eliminarlo
          habilitado: widget.jugador.habilitado);
      //Almacenar en base de datos SQLite
      //DBHelper.save(j);

      //Almacenar al jugador en la Box de 'jugadores'
      /*if (Hive.isBoxOpen('jugadores')) {
        boxJugadores.putAt(widget.posicion, j);
        //print("Jugador ${j.nombre}");
      } else {
        abrirBoxJugadores();
        boxJugadores.putAt(widget.posicion, j);
        //print("Jugador ${j.nombre}");
      }
      Navigator.pop(context);*/
      //Abrir box
      await Hive.openBox('jugadores');
      boxJugadores = Hive.box('jugadores');
      //Almacenar al jugador en la Box de 'jugadores'
      boxJugadores.putAt(widget.posicion, j);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GestionJugadores()),
      );
    }
  }

  void abrirBoxJugadores() async {
    //Abrir box
    boxJugadores = await Hive.openBox('jugadores');
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    _posicionesDisponibles = getDropDownMenuItems();
    _isSelected = [true, false];

    //Iniciar Box de jugadores
    //abrirBoxJugadores();

    super.initState();

    //Poner valores del jugador
    //Foto
    imgString = widget.jugador.nombre_foto;
    //Fecha nacimiento
    fechaNacimiento = widget.jugador.fechaNacimiento;
    //Pierna buena
    if (widget.jugador.piernaBuena == "Derecha") {
      //Derecha
      piernaDerechaBuena = true;
      _isSelected[0] = true;
      _isSelected[1] = false;
    } else {
      //Izquierda
      piernaDerechaBuena = false;
      _isSelected[0] = false;
      _isSelected[1] = true;
    }
    //Posición
    posicionFavorita = widget.jugador.posicionFavorita;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      abrirBoxJugadores();
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Editando ${widget.jugador.nombre}",
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ConversorImagen.imageFromBase64String(imgString, context),
                RaisedButton(
                  color: Colors.lightGreen,
                  child: Text("Añadir imagen"),
                  onPressed: () {
                    _elegirOpcionFotoDialogo(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 8),
                  child: Column(
                    children: <Widget>[
                      //Nombre
                      TextFormField(
                        initialValue: widget.jugador.nombre,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length == 0 ? 'Escribe el nombre' : null,
                        onSaved: (val) => nombre = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Nombre*',
                          hintText: 'Nombre del jugador',
                        ),
                      ),
                      separadorFormulario(),
                      //Apellido1
                      TextFormField(
                        initialValue: widget.jugador.apellido1,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length == 0 ? 'Escribe el primer apellido' : null,
                        onSaved: (val) => apellido1 = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Primer apellido*',
                          hintText: 'Primer apellido del jugador',
                        ),
                      ),
                      separadorFormulario(),
                      //Apellido2
                      TextFormField(
                        initialValue: widget.jugador.apellido2,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        /*validator: (val) => val.length == 0
                            ? 'Escribe el segundo apellido'
                            : null,*/
                        onSaved: (val) => apellido2 = val,
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
                        initialValue: widget.jugador.apodo,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        /*validator: (val) =>
                            val.length == 0 ? 'Escribe el apodo' : null,*/
                        onSaved: (val) => apodo = val,
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
                      separadorFormulario(),
                      //Anotaciones
                      TextFormField(
                        initialValue: widget.jugador.anotaciones,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        /*validator: (val) =>
                        val.length == 0 ? 'Escribe las anotaciones' : null,*/
                        onSaved: (val) => anotaciones = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Anotaciones sobre el jugador',
                          labelText: 'Anotaciones',
                        ),
                      ),
                      separadorFormulario(),
                      //Posición favorita Spinner
                      Column(
                        children: <Widget>[
                          Text("Posición favorita"),
                          DropdownButton(
                            elevation: 2,
                            iconSize: 40.0,
                            value: posicionFavorita,
                            items: _posicionesDisponibles,
                            onChanged: cambiarPosicion,
                          ),
                        ],
                      ),
                      separadorFormulario(),
                      //Pierna buena (derecha)
                      Column(
                        children: <Widget>[
                          Text("Pierna buena"),
                          ToggleButtons(
                            borderColor: Colors.blueAccent.withOpacity(.5),
                            selectedBorderColor: Colors.blueAccent,
                            children: <Widget>[
                              Container(
                                  width: (MediaQuery.of(context).size.width - 80) / 2,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.airline_seat_legroom_normal,
                                        color: Colors.teal,
                                        size: MediaQuery.of(context).size.width / 15,
                                      ),
                                      new Text(
                                        "DERECHA",
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: MediaQuery.of(context).size.width / 25,
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                width: (MediaQuery.of(context).size.width - 80) / 2,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(
                                      Icons.airline_seat_legroom_normal,
                                      color: Colors.brown,
                                      size: MediaQuery.of(context).size.width / 15,
                                    ),
                                    new Text(
                                      "IZQUIERDA",
                                      style: TextStyle(
                                        color: Colors.brown,
                                        fontSize: MediaQuery.of(context).size.width / 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _isSelected.length; i++) {
                                  if (i == index) {
                                    //Izquierda
                                    _isSelected[i] = true;
                                    piernaDerechaBuena = false;
                                  } else {
                                    //Derecha
                                    _isSelected[i] = false;
                                    piernaDerechaBuena = true;
                                  }
                                }
                                //Preselección derecha
                                piernaDerechaBuena = _isSelected[0];
                              });
                            },
                            isSelected: _isSelected,
                          ),
                        ],
                      ),
                      separadorFormulario(),
                      //Fecha de nacimiento
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar fecha
                          DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(1950, 1, 1), maxTime: DateTime.now(),
                              onConfirm: (date) {
                            setState(() {
                              fechaNacimiento = "${date.year}-${date.month}-${date.day}";
                            });
                          },
                              currentTime: DateTime(
                                int.parse(fechaNacimiento.split("-")[0]),
                                int.parse(fechaNacimiento.split("-")[1]),
                                int.parse(fechaNacimiento.split("-")[2]),
                              ),
                              locale: LocaleType.es);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Fecha de nacimiento",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width / 25,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "${fechaNacimiento}",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width / 25,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: MediaQuery.of(context).size.width / 25,
                                ),
                              ],
                            ),
                          ],
                        ),
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
                      child: Text("Editar jugador"),
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
  Widget separadorFormulario() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .015,
      width: MediaQuery.of(context).size.width,
    );
  }

  /* POSICIONES */

  //Hacer el Spinner de posiciones
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String p in _posiciones) {
      items.add(new DropdownMenuItem(value: p, child: new Text(p)));
    }
    return items;
  }

  //Actualizar la posición cuando eliges en el Spinner
  void cambiarPosicion(posicionElegida) {
    setState(() {
      posicionFavorita = posicionElegida;
    });
  }

  /* FOTOS */

  //Diálogo elegir forma de coger foto
  Future<void> _elegirOpcionFotoDialogo(BuildContext context) {
    //Estilo
    RoundedRectangleBorder _formaDialogo = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.black26));
    RoundedRectangleBorder _formaBoton = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
    BoxDecoration _formaBotones = BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.lightBlue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(15.0));
    BoxDecoration _formaBotonEliminar = BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.redAccent]),
        borderRadius: BorderRadius.circular(15.0));
    SizedBox _separadorBotonesDialogo = SizedBox(height: MediaQuery.of(context).size.height * .015, width: MediaQuery.of(context).size.width);
    //Diálogo
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: _formaDialogo,
            title: Text(
              (imgString != "") ? "Editar imagen" : "Añadir imagen",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * .07, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    width: MediaQuery.of(context).size.width * .45,
                    decoration: _formaBotones,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            _abrirGaleria(context);
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(Icons.photo),
                                Text(
                                  "Galería",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * .07,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  _separadorBotonesDialogo,
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    width: MediaQuery.of(context).size.width * .45,
                    decoration: _formaBotones,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            _abrirCamara(context);
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(Icons.camera_alt),
                                Text(
                                  "Cámara",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * .065,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  _separadorBotonesDialogo,
                  /*RaisedButton(
                    shape: _formaBoton,
                    child: Container(
                      decoration: _degradadoBotones,
                      width: MediaQuery.of(context).size.width * .32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(Icons.photo),
                          Text(
                            "Galería",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * .05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      _abrirGaleria(context);
                    },
                  ),*/
                  (imgString != "")
                      ? Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          width: MediaQuery.of(context).size.width * .45,
                          decoration: _formaBotonEliminar,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  _eliminarImagen();
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Icon(Icons.close),
                                      Text(
                                        "Eliminar",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * .06,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )
                      : Container(
                          width: 0,
                        ),
                ],
              ),
            ),
          );
        });
  }

  //Recortar imagen
  void _recortarImagen(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recortar imagen',
            toolbarColor: MisterFootball.primario,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ));
    this.setState(() {
      imgString = ConversorImagen.base64String(croppedFile.readAsBytesSync());
    });
    /*if (croppedFile != null) {
      this.setState(() {
        imgString = ConversorImagen.base64String(croppedFile.readAsBytesSync());
      });
    }*/
  }

  //Coger imagen de la galería
  void _abrirGaleria(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      if (imgFile != null) {
        /*this.setState(() {
          imgString = ConversorImagen.base64String(imgFile.readAsBytesSync());
        });*/
        _recortarImagen(imgFile);
      }
    });
    Navigator.of(context).pop();
  }

  //Sacar foto
  void _abrirCamara(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      if (imgFile != null) {
        _recortarImagen(imgFile);
        /*this.setState(() {
          imgString = ConversorImagen.base64String(imgFile.readAsBytesSync());
        });*/
      }
    });
    Navigator.of(context).pop();
  }

  //Eliminar foto
  void _eliminarImagen() {
    this.setState(() {
      imgString = "";
    });
    Navigator.of(context).pop();
  }
}
