import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/v_detalles_partido.dart';

const String testDevice = 'MobileId';

class ListaPartidos extends StatefulWidget {
  @override
  createState() => _ListaPartidos();
}

class _ListaPartidos extends State<ListaPartidos> {
  @override
  void dispose() {
    Hive.close();
    //myBanner.dispose();
    super.dispose();
  }

  //Devuelve el item de la lista de los partidos
  Widget itemPartidos() {
    //Estilo de los textos de los equipos
    TextStyle estiloEquipos = TextStyle(fontWeight: FontWeight.bold, color: MisterFootball.primarioDark);
    //Estilo de los textos
    TextStyle estiloTextos = TextStyle(color: MisterFootball.primarioDark);
    //Estilo de las fechas
    TextStyle estiloFechasTextos = TextStyle(
      color: MisterFootball.primarioDark,
      fontSize: MediaQuery.of(context).size.width * .025,
    );
    //Estilo de los resultados de los equipos
    TextStyle estiloResultado = TextStyle(
      fontSize: MediaQuery.of(context).size.width * .04,
      fontWeight: FontWeight.bold,
      color: MisterFootball.primarioDark,
    );
    final boxPartidos = Hive.box('partidos');
    final boxPerfil = Hive.box('perfil');
    List partidosOrdenados = [];
    for (var i = 0; i < boxPartidos.length; i++) {
      partidosOrdenados.add([i, boxPartidos.getAt(i).fecha, boxPartidos.getAt(i).hora]);
    }
    //Ordenar por hora
    partidosOrdenados.sort((a, b) => (a[2]).compareTo(b[2]));
    //Ordenar por fecha
    partidosOrdenados.sort((a, b) => (a[1]).compareTo(b[1]));
    print(partidosOrdenados);
    Map<String, dynamic> perfil = {"nombre_equipo": "Mi equipo", "escudo": ""};
    if (boxPerfil.get(0) != null) {
      perfil = Map.from(boxPerfil.get(0));
    }
    if (boxPartidos.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(boxPartidos.length, (iPartido) {
          //Poner primero los más nuevos
          final Partido partidoBox = boxPartidos.getAt(partidosOrdenados[((partidosOrdenados.length - 1) - iPartido)][0]) as Partido;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: new InkWell(
              splashColor: MisterFootball.complementario,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesPartido(
                      posicion: partidosOrdenados[((partidosOrdenados.length - 1) - iPartido)][0],
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black),
                  color:
                      /*(partidoBox.golesAFavor.length > partidoBox.golesEnContra.length)
                      //Victoria
                      ? Colors.lightGreen.withOpacity(.75)
                      //Derrota
                      : (partidoBox.golesAFavor.length < partidoBox.golesEnContra.length)
                          ? Colors.red.withOpacity(.6)
                          //Sin jugar
                          :*/
                      (DateTime.now()
                                  .difference(DateTime(
                                    int.parse(partidoBox.fecha.split("-")[0]),
                                    int.parse(partidoBox.fecha.split("-")[1]),
                                    int.parse(partidoBox.fecha.split("-")[2]),
                                    //Suponiendo que los partidos duran aproximadamente 1 hora y media
                                    int.parse(partidoBox.hora.split(":")[0]) + 1,
                                    int.parse(partidoBox.hora.split(":")[1]) + 30,
                                  ))
                                  .inSeconds >
                              0)
                          ? Colors.white
                          : Colors.yellow.withOpacity(.15),
                ),
                child: (DateTime.now()
                            .difference(DateTime(
                              int.parse(partidoBox.fecha.split("-")[0]),
                              int.parse(partidoBox.fecha.split("-")[1]),
                              int.parse(partidoBox.fecha.split("-")[2]),
                              //Suponiendo que los partidos duran aproximadamente 1 hora y media
                              int.parse(partidoBox.hora.split(":")[0]) + 1,
                              int.parse(partidoBox.hora.split(":")[1]) + 30,
                            ))
                            .inSeconds >
                        0)
                    ? (partidoBox.isLocal)
                        //Partido de local
                        ? Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: MisterFootball.complementarioLight),
                                  ),
                                ),
                                children: [
                                  //Nuestro Escudo
                                  ConversorImagen.devolverEscudoImageFromBase64String(perfil['escudo'], context),
                                  //Nosotros
                                  Text(
                                    perfil['nombre_equipo'],
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  Text(
                                    "${partidoBox.golesAFavor.length}-${partidoBox.golesEnContra.length}",
                                    style: estiloResultado,
                                    textAlign: TextAlign.center,
                                  ),
                                  //Rival
                                  Text(
                                    partidoBox.rival,
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  //Escudo Rival
                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.blueAccent,
                                    size: MediaQuery.of(context).size.width / 6,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(),
                                  //Tipo
                                  Text(
                                    partidoBox.tipoPartido,
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  //Hora
                                  Text(
                                    "${partidoBox.hora}",
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  //Fecha
                                  Text(
                                    "${partidoBox.fecha.split("-")[2]}-${partidoBox.fecha.split("-")[1]}-${partidoBox.fecha.split("-")[0]}",
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  Container(),
                                ],
                              ),
                            ],
                          )
                        //Partido de visitante
                        : Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: MisterFootball.complementarioLight),
                                  ),
                                ),
                                children: [
                                  //Escudo Rival
                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.blueAccent,
                                    size: MediaQuery.of(context).size.width / 6,
                                  ),
                                  //Rival
                                  Text(
                                    partidoBox.rival,
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  Text(
                                    "${partidoBox.golesAFavor.length}-${partidoBox.golesEnContra.length}",
                                    style: estiloResultado,
                                    textAlign: TextAlign.center,
                                  ),
                                  //Nosotros
                                  Text(
                                    perfil['nombre_equipo'],
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  //Nuestro Escudo
                                  ConversorImagen.devolverEscudoImageFromBase64String(perfil['escudo'], context),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(),
                                  //Tipo
                                  Text(
                                    partidoBox.tipoPartido,
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  //Hora
                                  Text(
                                    "${partidoBox.hora}",
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  //Fecha
                                  Text(
                                    "${partidoBox.fecha.split("-")[2]}-${partidoBox.fecha.split("-")[1]}-${partidoBox.fecha.split("-")[0]}",
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  Container(),
                                ],
                              ),
                            ],
                          )
                    //Sin jugar local
                    : (partidoBox.isLocal)
                        ? Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                /*decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: MisterFootball.complementarioLight),
                                  ),
                                ),*/
                                children: [
                                  //Nuestro Escudo
                                  ConversorImagen.devolverEscudoImageFromBase64String(perfil['escudo'], context),
                                  //Nosotros
                                  Text(
                                    perfil['nombre_equipo'],
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  //Fecha y hora
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        //Hora
                                        Text(
                                          "${partidoBox.hora}",
                                          textAlign: TextAlign.center,
                                          style: estiloTextos,
                                        ),
                                        //Fecha
                                        Text(
                                          "${partidoBox.fecha.split("-")[2]}-${partidoBox.fecha.split("-")[1]}-${partidoBox.fecha.split("-")[0]}",
                                          textAlign: TextAlign.center,
                                          style: estiloFechasTextos,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Rival
                                  Text(
                                    partidoBox.rival,
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  //Escudo Rival
                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.blueAccent,
                                    size: MediaQuery.of(context).size.width / 6,
                                  ),
                                ],
                              ),
                              /*TableRow(
                                children: [
                                  Container(),
                                  //Tipo
                                  Text(
                                    "Sin disputar",
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  Container(),
                                  //Tipo
                                  Text(
                                    partidoBox.tipoPartido,
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  Container(),
                                ],
                              ),*/
                            ],
                          )
                        //Sin jugar visitante
                        : Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                /*decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: MisterFootball.complementarioLight),
                                  ),
                                ),*/
                                children: [
                                  //Escudo Rival
                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.blueAccent,
                                    size: MediaQuery.of(context).size.width / 6,
                                  ),
                                  //Rival
                                  Text(
                                    partidoBox.rival,
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  //Fecha y hora
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        //Hora
                                        Text(
                                          "${partidoBox.hora}",
                                          textAlign: TextAlign.center,
                                          style: estiloTextos,
                                        ),
                                        //Fecha
                                        Text(
                                          "${partidoBox.fecha.split("-")[2]}-${partidoBox.fecha.split("-")[1]}-${partidoBox.fecha.split("-")[0]}",
                                          textAlign: TextAlign.center,
                                          style: estiloFechasTextos,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Nosotros
                                  Text(
                                    perfil['nombre_equipo'],
                                    textAlign: TextAlign.center,
                                    style: estiloEquipos,
                                  ),
                                  //Nuestro Escudo
                                  ConversorImagen.devolverEscudoImageFromBase64String(perfil['escudo'], context),
                                ],
                              ),
                              /*TableRow(
                                children: [
                                  Container(),
                                  //Tipo
                                  Text(
                                    "Sin disputar",
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  Container(),
                                  //Tipo
                                  Text(
                                    partidoBox.tipoPartido,
                                    textAlign: TextAlign.center,
                                    style: estiloTextos,
                                  ),
                                  Container(),
                                ],
                              ),*/
                            ],
                          ),
              ),
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún partido creado."),
      );
    }
  }

  Future<void> _openBox() async {
    await Hive.openBox("partidos");
    await Hive.openBox("perfil");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: _openBox(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text(snapshot.error.toString());
                    } else {
                      return itemPartidos();
                    }
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
