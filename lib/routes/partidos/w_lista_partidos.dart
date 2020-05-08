import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    final boxPartidos = Hive.box('partidos');
    final boxPerfil = Hive.box('perfil');
    if (boxPartidos.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(boxPartidos.length, (iPartido) {
          final Partido partidoBox = boxPartidos.getAt(iPartido) as Partido;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new InkWell(
              splashColor: MisterFootball.complementario,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesPartido(
                      posicion: iPartido,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Representar el tipo de partido cambiando el color
                    //Mostrar el orden del resultado según si es local o visitante
                    Text(
                      (partidoBox.isLocal)
                          ? "${partidoBox.golesAFavor.length}-${partidoBox.golesEnContra.length}"
                          : "${partidoBox.golesEnContra.length}-${partidoBox.golesAFavor.length}",
                    ),
                    //Rival
                    Text(
                      partidoBox.rival,
                      textAlign: TextAlign.center,
                    ),
                    //Tipo
                    Text(
                      partidoBox.tipoPartido,
                      textAlign: TextAlign.center,
                    ),
                    //Fecha
                    Text(
                      partidoBox.fecha,
                      textAlign: TextAlign.center,
                    ),
                    //Hora
                    Text(
                      partidoBox.hora,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
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
