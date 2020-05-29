import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/navigator/Navegador.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:image_cropper/image_cropper.dart';

class Configuracion extends StatefulWidget {
  Configuracion({Key key}) : super(key: key);

  @override
  _Configuracion createState() => _Configuracion();
}

class _Configuracion extends State<Configuracion> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String imgString;
  bool isEscudoEditado;
  String nombreEquipo;
  bool isNombreEquipoEditado;

  @override
  void initState() {
    super.initState();
    imgString = "";
    nombreEquipo = "";
    isEscudoEditado = false;
    isNombreEquipoEditado = false;
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  //Devuelve la lista de configuración
  Widget devolverConfiguracion() {
    final boxPerfil = Hive.box('perfil');
    Map<String, dynamic> equipo = {
      "nombre_equipo": "",
      "escudo": "",
      "modo_oscuro": false,
      "alineacion_favorita": [
        {'0': null, '1': null, '2': null, '3': null, '4': null, '5': null, '6': null, '7': null, '8': null, '9': null, '10': null},
        "14231"
      ]
    };
    if (boxPerfil.get(0) != null) {
      equipo = Map.from(boxPerfil.get(0));
    }
    Map<String, dynamic> equipoEditado = equipo;
    if (boxPerfil.length > 0) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .9,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: MisterFootball.primario,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                "Escudo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .05,
                  color: Colors.white70,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                (!isEscudoEditado)
                    ? ConversorImagen.devolverEscudoImageFromBase64String(equipo['escudo'], context)
                    : ConversorImagen.devolverEscudoImageFromBase64String(imgString, context),
                IconButton(
                  icon: Icon(
                    Icons.mode_edit,
                    color: MisterFootball.complementarioDark,
                  ),
                  onPressed: () async {
                    if (!isEscudoEditado) {
                      _elegirOpcionFotoDialogo(equipo['escudo'], context);
                    } else {
                      _elegirOpcionFotoDialogo(imgString, context);
                    }
                  },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: MisterFootball.primario,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                "Nombre del equipo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .05,
                  color: Colors.white70,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                Text(
                  (!isNombreEquipoEditado)
                      ? (equipo['nombre_equipo'].length == 0) ? "-" : equipo['nombre_equipo']
                      : (nombreEquipo.length == 0) ? "-" : nombreEquipo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * .04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.mode_edit,
                    color: MisterFootball.complementarioDark,
                  ),
                  onPressed: () async {
                    print(isNombreEquipoEditado);
                    _cambiarNombreEquipo(context, (!isNombreEquipoEditado) ? equipo['nombre_equipo'] : nombreEquipo);
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RaisedButton(
                child: Text("Aceptar"),
                onPressed: (!isEscudoEditado && !isNombreEquipoEditado)
                    ? null
                    : () {
                        //Escudo editado y nombre NO editado
                        if (isEscudoEditado && !isNombreEquipoEditado) {
                          equipoEditado = {
                            "nombre_equipo": equipo['nombre_equipo'],
                            "escudo": "$imgString",
                            "modo_oscuro": false,
                            "alineacion_favorita": equipo["alineacion_favorita"]
                          };
                        } else {
                          //Nombre editado y escudo NO editado
                          if (!isEscudoEditado && isNombreEquipoEditado) {
                            equipoEditado = {
                              "nombre_equipo": "$nombreEquipo",
                              "escudo": equipo['escudo'],
                              "modo_oscuro": false,
                              "alineacion_favorita": equipo["alineacion_favorita"]
                            };
                          } else {
                            equipoEditado = {
                              "nombre_equipo": "$nombreEquipo",
                              "escudo": "$imgString",
                              "modo_oscuro": false,
                              "alineacion_favorita": equipo["alineacion_favorita"]
                            };
                          }
                        }
                        //boxPerfil.putAt(0, equipoEditado);
                        boxPerfil.putAt(0, equipoEditado);
                        setState(() {
                          isEscudoEditado = false;
                          isNombreEquipoEditado = false;
                        });
                      },
              ),
            ),
          ],
        ),
      );
      /*return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              Text("Escudo:"),
              (!isEscudoEditado)
                  ? ConversorImagen.devolverEscudoImageFromBase64String(equipo['escudo'], context)
                  : ConversorImagen.devolverEscudoImageFromBase64String(imgString, context),
              IconButton(
                icon: Icon(
                  Icons.mode_edit,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () async {
                  if (!isEscudoEditado) {
                    _elegirOpcionFotoDialogo(equipo['escudo'], context);
                  } else {
                    _elegirOpcionFotoDialogo(imgString, context);
                  }
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text("Nombre del equipo:"),
              Text(
                (!isNombreEquipoEditado)
                    ? (equipo['nombre_equipo'].length == 0) ? "-" : equipo['nombre_equipo']
                    : (nombreEquipo.length == 0) ? "-" : nombreEquipo,
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(
                  Icons.mode_edit,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () async {
                  print(isNombreEquipoEditado);
                  _cambiarNombreEquipo(context, (!isNombreEquipoEditado) ? equipo['nombre_equipo'] : nombreEquipo);
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                height: 0,
              ),
              RaisedButton(
                child: Text("Aceptar"),
                onPressed: (!isEscudoEditado && !isNombreEquipoEditado)
                    ? null
                    : () {
                        //Escudo editado y nombre NO editado
                        if (isEscudoEditado && !isNombreEquipoEditado) {
                          equipoEditado = {
                            "nombre_equipo": equipo['nombre_equipo'],
                            "escudo": "$imgString",
                            "modo_oscuro": false,
                            "alineacion_favorita": equipo["alineacion_favorita"]
                          };
                        } else {
                          //Nombre editado y escudo NO editado
                          if (!isEscudoEditado && isNombreEquipoEditado) {
                            equipoEditado = {
                              "nombre_equipo": "$nombreEquipo",
                              "escudo": equipo['escudo'],
                              "modo_oscuro": false,
                              "alineacion_favorita": equipo["alineacion_favorita"]
                            };
                          } else {
                            equipoEditado = {
                              "nombre_equipo": "$nombreEquipo",
                              "escudo": "$imgString",
                              "modo_oscuro": false,
                              "alineacion_favorita": equipo["alineacion_favorita"]
                            };
                          }
                        }
                        //boxPerfil.putAt(0, equipoEditado);
                        boxPerfil.putAt(0, equipoEditado);
                        setState(() {
                          isEscudoEditado = false;
                          isNombreEquipoEditado = false;
                        });
                      },
              ),
              Container(
                height: 0,
              ),
            ],
          ),
        ],
      );*/
    } else {
      return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              Text("Escudo:"),
              ConversorImagen.devolverEscudoImageFromBase64String(imgString, context),
              IconButton(
                icon: Icon(
                  Icons.mode_edit,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () async {
                  _elegirOpcionFotoDialogo(equipo['escudo'], context);
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text("Nombre del equipo:"),
              Text(
                (nombreEquipo.length == 0) ? "-" : nombreEquipo,
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(
                  Icons.mode_edit,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () async {
                  _cambiarNombreEquipo(context, nombreEquipo);
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                height: 0,
              ),
              RaisedButton(
                child: Text("Aceptar"),
                onPressed: (!isEscudoEditado && !isNombreEquipoEditado)
                    ? null
                    : () {
                        //Escudo editado y nombre NO editado
                        if (isEscudoEditado && !isNombreEquipoEditado) {
                          equipoEditado = {
                            "nombre_equipo": "",
                            "escudo": "$imgString",
                            "modo_oscuro": false,
                            "alineacion_favorita": equipo["alineacion_favorita"]
                          };
                        } else {
                          //Nombre editado y escudo NO editado
                          if (!isEscudoEditado && isNombreEquipoEditado) {
                            equipoEditado = {
                              "nombre_equipo": "$nombreEquipo",
                              "escudo": "",
                              "modo_oscuro": false,
                              "alineacion_favorita": equipo["alineacion_favorita"]
                            };
                          } else {
                            equipoEditado = {
                              "nombre_equipo": "$nombreEquipo",
                              "escudo": "$imgString",
                              "modo_oscuro": false,
                              "alineacion_favorita": equipo["alineacion_favorita"]
                            };
                          }
                        }
                        //boxPerfil.putAt(0, equipoEditado);
                        boxPerfil.add(equipoEditado);
                        setState(() {
                          isEscudoEditado = false;
                          isNombreEquipoEditado = false;
                        });
                      },
              ),
              Container(
                height: 0,
              ),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        drawer: Drawer(
          child: Navegador(),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menú',
            onPressed: () async {
              _drawerKey.currentState.openDrawer();
            },
          ),
          title: Text(
            'Configuración',
          ),
        ),
        body: FutureBuilder(
          future: Hive.openBox('perfil'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else {
                return devolverConfiguracion();
              }
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  /* NOMBRE EQUIPO */
  //Diálogo cambiar nombre equipo
  Future<String> _cambiarNombreEquipo(BuildContext context, String strEquipo) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    //Estilo
    RoundedRectangleBorder _formaDialogo = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.black26));
    BoxDecoration _formaBotones = BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.lightBlue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(15.0));
    //Diálogo
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: _formaDialogo,
            title: Text(
              "Nombre equipo:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * .07, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      (MediaQuery.of(context).size.height * .01),
                      0,
                      (MediaQuery.of(context).size.height * .01),
                    ),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        initialValue: strEquipo,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        validator: (val) => (val.length == 0) ? 'Escribe el nombre del equipo' : null,
                        onChanged: (val) => nombreEquipo = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Nombre del equipo',
                          hintText: 'Nombre del equipo',
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Aceptar"),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        setState(() {
                          isNombreEquipoEditado = true;
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  /* FOTOS */

  //Diálogo elegir forma de coger foto
  Future<void> _elegirOpcionFotoDialogo(String imagenEscudo, BuildContext context) {
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
                  (imagenEscudo != "")
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
      isEscudoEditado = true;
      imgString = ConversorImagen.base64String(croppedFile.readAsBytesSync());
    });
  }

  //Coger imagen de la galería
  void _abrirGaleria(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      if (imgFile != null) {
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
      }
    });
    Navigator.of(context).pop();
  }

  //Eliminar foto
  void _eliminarImagen() {
    this.setState(() {
      isEscudoEditado = true;
      imgString = "";
    });
    Navigator.of(context).pop();
  }
}
