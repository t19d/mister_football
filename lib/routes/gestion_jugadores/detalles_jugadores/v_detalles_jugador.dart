import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/gestion_jugadores_edicion_creacion/v_gestion_jugadores_edicion.dart';
import 'package:mister_football/routes/gestion_jugadores/v_gestion_jugadores.dart';

class DetallesJugador extends StatefulWidget {
  final int posicion;

  DetallesJugador({Key key, @required this.posicion}) : super(key: key);

  @override
  _DetallesJugador createState() => _DetallesJugador();
}

class _DetallesJugador extends State<DetallesJugador> {
  Jugador jugador;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle estiloTexto = TextStyle(fontSize: MediaQuery.of(context).size.width * .05);

    return FutureBuilder(
      future: Hive.openBox('jugadores'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxJugadores = Hive.box('jugadores');
            jugador = boxJugadores.getAt(widget.posicion);
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: (jugador.habilitado) ? Text("") : Text("DESHABILITADO"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      tooltip: 'Editar jugador',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GestionJugadoresEdicion(
                              jugador: jugador,
                              posicion: widget.posicion,
                            ),
                          ),
                        );
                      },
                    ),
                    (jugador.habilitado)
                        ? IconButton(
                            icon: Icon(
                              Icons.visibility_off,
                              color: MisterFootball.complementarioDelComplementarioLight,
                            ),
                            tooltip: 'Deshabilitar jugador',
                            onPressed: () async {
                              //Borrar de la alineación favorita
                              Box boxPerfil = await Hive.openBox('perfil');
                              Map<String, dynamic> equipo = {
                                "nombre_equipo": "",
                                "escudo": "",
                                "modo_oscuro": false,
                                "alineacion_favorita": [
                                  {
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
                                  },
                                  "14231"
                                ]
                              };
                              if (boxPerfil.get(0) != null) {
                                equipo = Map.from(boxPerfil.get(0));
                              }
                              for (var j = 0; j < equipo["alineacion_favorita"][0].length; j++) {
                                print(equipo["alineacion_favorita"][0]["$j"]);
                                if (equipo["alineacion_favorita"][0]["$j"] == jugador.id) {
                                  equipo["alineacion_favorita"][0]["$j"] = null;
                                }
                              }

                              //Deshabilitar jugador
                              Box boxJugadores = await Hive.openBox('jugadores');
                              Jugador j = Jugador(
                                  nombre_foto: jugador.nombre_foto,
                                  nombre: jugador.nombre,
                                  apellido1: jugador.apellido1,
                                  apellido2: jugador.apellido2,
                                  apodo: jugador.apodo,
                                  anotaciones: jugador.anotaciones,
                                  posicionFavorita: jugador.posicionFavorita,
                                  piernaBuena: jugador.piernaBuena,
                                  fechaNacimiento: jugador.fechaNacimiento,
                                  id: jugador.id,
                                  //Deshabilitar jugador
                                  habilitado: false);
                              //Almacenar al jugador en la Box de 'jugadores'
                              boxJugadores.putAt(widget.posicion, j);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => GestionJugadores()),
                              );
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: MisterFootball.complementarioDelComplementarioLight,
                            ),
                            tooltip: 'Eliminar jugador',
                            onPressed: () async {
                              //DBHelper.delete(widget.jugador.id);
                              Box boxJugadores = await Hive.openBox('jugadores');
                              Box boxPerfil = await Hive.openBox('perfil');
                              print(widget.posicion);
                              boxJugadores.deleteAt(widget.posicion);

                              //Borrar de la alineación favorita
                              Map<String, dynamic> equipo = {
                                "nombre_equipo": "",
                                "escudo": "",
                                "modo_oscuro": false,
                                "alineacion_favorita": [
                                  {
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
                                  },
                                  "14231"
                                ]
                              };
                              if (boxPerfil.get(0) != null) {
                                equipo = Map.from(boxPerfil.get(0));
                              }
                              for (var j = 0; j < equipo["alineacion_favorita"][0].length; j++) {
                                print(equipo["alineacion_favorita"][0]["$j"]);
                                if (equipo["alineacion_favorita"][0]["$j"] == jugador.id) {
                                  equipo["alineacion_favorita"][0]["$j"] = null;
                                }
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => GestionJugadores()),
                              );
                            },
                          ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
                        decoration: BoxDecoration(
                          color: MisterFootball.primarioLight2.withOpacity(.25),
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            //Foto
                            ConversorImagen.imageFromBase64String(jugador.nombre_foto, context),
                            Container(
                              padding: EdgeInsets.only(
                                bottom: 5,
                                left: 10,
                              ),
                              child: Text(
                                "${jugador.apodo}",
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Datos prepartido
                      Container(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .03,
                          right: MediaQuery.of(context).size.width * .03,
                        ),
                        child: Table(
                          border: TableBorder(
                            verticalInside: BorderSide(
                              color: MisterFootball.primario,
                              width: .4,
                            ),
                          ),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: [
                            //Nombre
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Nombre",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    jugador.nombre,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Primer apellido
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Primer apellido",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    jugador.apellido1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Segundo apellido
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Segundo apellido",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    (jugador.apellido2.length == 0) ? "-" : jugador.apellido2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Apodo
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Apodo",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    jugador.apodo,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Fecha de nacimiento (Edad)
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Fecha de nacimiento\n(Edad)",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    "${jugador.fechaNacimiento.split("-")[2]}-${jugador.fechaNacimiento.split("-")[1]}-"
                                    "${jugador.fechaNacimiento.split("-")[0]}\n(${jugador.calcularEdad()} años)",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Pierna buena
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Pierna buena",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    jugador.piernaBuena,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Posición favorita
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Posición favorita",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    jugador.posicionFavorita,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            //Anotaciones
                            TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: MisterFootball.primario, width: .4),
                                ),
                              ),
                              children: [
                                Text(
                                  "Anotaciones",
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * .03,
                                    bottom: MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: Text(
                                    (jugador.anotaciones.length == 0) ? "-" : jugador.anotaciones,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //Histórico y estadísticas
                      /*Container(
                        decoration: BoxDecoration(
                          color: MisterFootball.primarioLight2.withOpacity(.05),
                          border: Border(
                            top: BorderSide(width: .4),
                            bottom: BorderSide(width: .4),
                          ),
                        ),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * .03,
                          top: MediaQuery.of(context).size.width * .03,
                        ),
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .03,
                          right: MediaQuery.of(context).size.width * .03,
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Goles a favor",
                              style: tituloEventos,
                            ),
                            mostrarListaGolesAFavor(widget.partido),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                  /*child: Container(
                    padding: EdgeInsets.all(MediaQuery
                        .of(context)
                        .size
                        .width * .025),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Apodo
                        /*Text(jugador.apodo, style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05),),*/
                        //Foto  | Nombre  | Apellido1 | Apellido2
                        //Foto  | Edad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //Foto
                            ConversorImagen.imageFromBase64String(jugador.nombre_foto, context),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Nombre  | Apellido1 | Apellido2
                                Text(
                                  "${jugador.nombre} ${jugador.apellido1} ${jugador.apellido2}",
                                  style: estiloTexto,
                                ),
                                //Edad
                                Text(
                                  "${jugador.calcularEdad()} años (${jugador.fechaNacimiento.split("-")[2]}-${jugador.fechaNacimiento.split(
                                      "-")[1]}-${jugador.fechaNacimiento.split("-")[0]})",
                                  style: estiloTexto,
                                ),
                              ],
                            ),
                          ],
                        ),
                        divisorGrupos,
                        //Nombre
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Nombre:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.nombre,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Nombre: " + jugador.nombre),
                        divisorElementos,
                        //Primer apellido
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Primer apellido:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.apellido1,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Primer apellido: " + jugador.apellido1),
                        divisorElementos,
                        //Segundo apellido
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Segundo apellido:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.apellido2,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Segundo apellido: " + jugador.apellido2),
                        divisorElementos,
                        //Apodo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Apodo:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.apodo,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Apodo: " + jugador.apodo),
                        divisorElementos,
                        //Pierna buena
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Pierna buena:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.piernaBuena,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Pierna buena: " + jugador.piernaBuena),
                        divisorElementos,
                        //Posición favorita
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Posición favorita:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.posicionFavorita,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Posición favorita: " + jugador.posicionFavorita),
                        divisorElementos,
                        //Anotaciones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Anotaciones:",
                              style: estiloTexto,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .4,
                              child: Text(
                                jugador.anotaciones,
                                textAlign: TextAlign.right,
                                style: estiloTexto,
                              ),
                            ),
                          ],
                        ),
                        //Text("Anotaciones: " + jugador.anotaciones),
                        divisorGrupos,
                        //Historial y medias
                        /*Text(
                        "Histórico",
                        style: estiloTexto,
                      ),*/
                      ],
                    ),
                  ),*/
                ),
              ),
            );
          }
        } else {
          /*return Center(
            child: CircularProgressIndicator(),
          );*/
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
                  decoration: BoxDecoration(
                    color: MisterFootball.primarioLight2.withOpacity(.25),
                    border: Border(bottom: BorderSide(width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //Foto
                      ConversorImagen.imageFromBase64String("", context),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: 5,
                          left: 10,
                        ),
                        child: Text(
                          "",
                          style: estiloTexto,
                        ),
                      ),
                    ],
                  ),
                ),
                //Datos prepartido
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .03,
                    right: MediaQuery.of(context).size.width * .03,
                  ),
                  child: Table(
                    border: TableBorder(
                      verticalInside: BorderSide(
                        color: MisterFootball.primario,
                        width: .4,
                      ),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      //Nombre
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Nombre",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Primer apellido
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Primer apellido",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Segundo apellido
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Segundo apellido",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Apodo
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Apodo",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Fecha de nacimiento (Edad)
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Fecha de nacimiento\n(Edad)",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Pierna buena
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Pierna buena",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Posición favorita
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Posición favorita",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //Anotaciones
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: MisterFootball.primario, width: .4),
                          ),
                        ),
                        children: [
                          Text(
                            "Anotaciones",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .03,
                              bottom: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
