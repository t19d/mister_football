import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/v_gestion_jugadores.dart';

class GestionJugadoresCreacion extends StatefulWidget {
  GestionJugadoresCreacion({Key key}) : super(key: key);

  @override
  _GestionJugadoresCreacion createState() => _GestionJugadoresCreacion();
}

class _GestionJugadoresCreacion extends State<GestionJugadoresCreacion> {
  //Box jugadores
  Box boxJugadores = null;

  //Datos
  DateTime fechaHoraInicial = DateTime.now();
  String nombre = "";
  String apellido1 = "";
  String apellido2 = "";
  String apodo = ""; //Opcional. En caso de estar vacío, se pone el apellido1
  String fechaNacimiento = "";
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
      String _apodoGuardar = (apodo.trim() != "") ? apodo.trim() : apellido1;
      String _claveJugador = "${DateTime.now()}+${nombre.trim()}+${apellido1.trim()}+${apellido2.trim()}+$_apodoGuardar+${fechaNacimiento.trim()}";
      print(_claveJugador);
      Jugador j = Jugador(
          nombre_foto: imgString,
          nombre: nombre.trim(),
          apellido1: apellido1.trim(),
          apellido2: apellido2.trim(),
          apodo: _apodoGuardar,
          anotaciones: anotaciones.trim(),
          posicionFavorita: posicionFavorita.trim(),
          piernaBuena: (piernaDerechaBuena ? "Derecha" : "Izquierda"),
          fechaNacimiento: fechaNacimiento.trim(),
          id: _claveJugador,
          habilitado: true);

      //Abrir box
      await Hive.openBox('jugadores');
      boxJugadores = Hive.box('jugadores');
      //Almacenar al jugador en la Box de 'jugadores'
      boxJugadores.add(j);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GestionJugadores()),
      );
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    _posicionesDisponibles = getDropDownMenuItems();
    posicionFavorita = _posicionesDisponibles[0].value;
    _isSelected = [true, false];
    imgString = "";
    fechaNacimiento = "${fechaHoraInicial.year}-" +
        ((fechaHoraInicial.month.toString().length == 1) ? "0${fechaHoraInicial.month}" : "${fechaHoraInicial.month}") +
        "-" +
        ((fechaHoraInicial.day.toString().length == 1) ? "0${fechaHoraInicial.day}" : "${fechaHoraInicial.day}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nuevo jugador',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
                  color: Colors.white70,
                  disabledColor: MisterFootball.colorPrimarioLight2,
                  disabledTextColor: Colors.white70,
                  child: (imgString == "") ? Text("Añadir foto") : Text("Editar foto"),
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
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (val) => val.length == 0 ? 'Escribe el nombre' : null,
                        onChanged: (val) => nombre = val,
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
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (val) => val.length == 0 ? 'Escribe el primer apellido' : null,
                        onChanged: (val) => apellido1 = val,
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
                        //Para que sea un campo opcional
                        initialValue: "",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        /*validator: (val) => val.length == 0
                            ? 'Escribe el segundo apellido'
                            : null,*/
                        onChanged: (val) => apellido2 = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Segundo apellido',
                          hintText: 'Segundo apellido del jugador',
                        ),
                      ),
                      separadorFormulario(),
                      //Apodo
                      TextFormField(
                        //Para que sea un campo opcional
                        initialValue: "",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        /*validator: (val) => val.length == 0 ? 'Escribe el apodo' : null,*/
                        onChanged: (val) => apodo = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Apodo',
                          hintText: 'Apodo del jugador',
                        ),
                      ),
                      separadorFormulario(),
                      //Anotaciones
                      TextFormField(
                        //Para que sea un campo opcional
                        initialValue: "",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        /*validator: (val) => val.length == 0 ? 'Escribe las anotaciones' : null,*/
                        onChanged: (val) => anotaciones = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Anotaciones',
                          hintText: 'Anotaciones sobre el jugador',
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
                      //Pierna buena
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
                        color: Colors.white70,
                        disabledColor: MisterFootball.colorPrimarioLight2,
                        disabledTextColor: Colors.white70,
                        onPressed: () {
                          //Seleccionar fecha
                          DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(1950, 1, 1), maxTime: DateTime.now(),
                              onConfirm: (date) {
                            setState(() {
                              fechaNacimiento = "${date.year}-" +
                                  ((date.month.toString().length == 1) ? "0${date.month}" : "${date.month}") +
                                  "-" +
                                  ((date.day.toString().length == 1) ? "0${date.day}" : "${date.day}");
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
                                  "${fechaNacimiento.split("-")[2]}-${fechaNacimiento.split("-")[1]}-${fechaNacimiento.split("-")[0]}",
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
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: MisterFootball.colorPrimario)),
                  color: Colors.white70,
                  disabledColor: MisterFootball.colorPrimarioLight2,
                  disabledTextColor: Colors.white70,
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
            toolbarColor: MisterFootball.colorPrimario,
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
