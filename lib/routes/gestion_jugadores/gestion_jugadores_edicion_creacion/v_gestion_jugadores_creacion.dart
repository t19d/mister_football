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

class GestionJugadoresCreacion extends StatefulWidget {
  GestionJugadoresCreacion({Key key}) : super(key: key);

  @override
  _GestionJugadoresCreacion createState() => _GestionJugadoresCreacion();
}

class _GestionJugadoresCreacion extends State<GestionJugadoresCreacion> {
  //Box jugadores
  Box boxJugadores = null;

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
  validar() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Jugador j = Jugador(
          nombre: nombre.trim(),
          apellido1: apellido1.trim(),
          apellido2: apellido2.trim(),
          apodo: apodo.trim(),
          fechaNacimiento: fechaNacimiento.trim(),
          piernaBuena: (piernaDerechaBuena ? "Derecha" : "Izquierda"),
          posicionFavorita: posicionFavorita.trim(),
          anotaciones: anotaciones.trim(),
          nombre_foto: imgString);
      //Almacenar en base de datos SQLite
      //DBHelper.save(j);

      //Almacenar al jugador en la Box de 'jugadores'
      if (Hive.isBoxOpen('jugadores')) {
        boxJugadores.add(j);
        //print("Jugador ${j.nombre}");
      } else {
        abrirBoxJugadores();
        boxJugadores.add(j);
        //print("Jugador ${j.nombre}");
      }
      Navigator.pop(context);
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
    posicionFavorita = _posicionesDisponibles[0].value;
    _isSelected = [true, false];

    //Iniciar Box de jugadores
    //abrirBoxJugadores();

    super.initState();
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
                  color: Colors.lightGreen,
                  child: Text("Editar foto"),
                  onPressed: () {
                    _elegirOpcionFotoDialogo(context);
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 8),
                  child: Column(
                    children: <Widget>[
                      //Nombre
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) =>
                            val.length == 0 ? 'Escribe el nombre' : null,
                        onChanged: (val) => nombre = val,
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
                      //Apellido1
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
                      separadorFormulario(),
                      //Fecha de nacimiento
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        onPressed: () {
                          //Seleccionar fecha
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1950, 1, 1),
                              maxTime: DateTime.now(), onConfirm: (date) {
                                setState(() {
                                  fechaNacimiento =
                                  "${date.year}-${date.month}-${date.day}";
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
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "${fechaNacimiento}",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
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
                      //Pierna buena (derecha)
                      Column(
                        children: <Widget>[
                          Text("Pierna buena"),
                          ToggleButtons(
                            borderColor: Colors.blueAccent.withOpacity(.5),
                            selectedBorderColor: Colors.blueAccent,
                            children: <Widget>[
                              Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 80) /
                                          2,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.airline_seat_legroom_normal,
                                        color: Colors.teal,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                15,
                                      ),
                                      new Text(
                                        "DERECHA",
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              25,
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width - 80) /
                                        2,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(
                                      Icons.airline_seat_legroom_normal,
                                      color: Colors.brown,
                                      size: MediaQuery.of(context).size.width /
                                          15,
                                    ),
                                    new Text(
                                      "IZQUIERDA",
                                      style: TextStyle(
                                        color: Colors.brown,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
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
                      //Anotaciones
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (val) =>
                            val.length == 0 ? 'Escribe las anotaciones' : null,
                        onChanged: (val) => anotaciones = val,
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

  //Hacer el Spinner de posiciones
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String p in _posiciones) {
      items.add(new DropdownMenuItem(value: p, child: new Text(p)));
    }
    return items;
  }

  //Actualizar la posición cuando eliges en el Spinner
  cambiarPosicion(posicionElegida) {
    setState(() {
      posicionFavorita = posicionElegida;
    });
  }

  /* FOTOS */

  //Diálogo elegir forma de coger foto
  Future<void> _elegirOpcionFotoDialogo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Elegir imagen"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: RaisedButton(
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.photo),
                                Text("Galería"),
                              ],
                            ),
                            onPressed: () {
                              _abrirGaleria(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: RaisedButton(
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.photo_camera),
                                Text("Cámara"),
                              ],
                            ),
                            onPressed: () {
                              _abrirCamara(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: RaisedButton(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Eliminar",
                                  /*style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 15,
                                  ),*/
                                ),
                              ],
                            ),
                            onPressed: () {
                              _eliminarImagen();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Recortar imagen
  _recortarImagen(File image) async {
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
  _abrirGaleria(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((imgFile) async {
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
  _abrirCamara(BuildContext context) async {
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
  _eliminarImagen() {
    this.setState(() {
      imgString = "";
    });
    Navigator.of(context).pop();
  }
}
