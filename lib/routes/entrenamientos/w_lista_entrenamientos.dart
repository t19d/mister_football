import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/entrenamientos/detalles_entrenamientos/v_detalles_entrenamientos.dart';

class ListaEntrenamientos extends StatefulWidget {
  @override
  createState() => _ListaEntrenamientos();
}

class _ListaEntrenamientos extends State<ListaEntrenamientos> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Widget itemEntrenamientos() {
    final boxEntrenamientos = Hive.box('entrenamientos');
    if (boxEntrenamientos.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(boxEntrenamientos.length, (iEntrenamiento) {
          final Entrenamiento entrenamientoBox = boxEntrenamientos.getAt(iEntrenamiento) as Entrenamiento;
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
                    builder: (context) => DetallesEnternamiento(
                      posicion: iEntrenamiento,
                    ),
                  ),
                );
              },
              child: Container(
                //padding: const EdgeInsets.only(top: 5.0, bottom: 6.0),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Hora
                        Text(
                          entrenamientoBox.hora,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                        //Fecha
                        Text(
                          entrenamientoBox.fecha,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("${entrenamientoBox.jugadoresOpiniones.length}"),
                        Icon(Icons.person),
                      ],
                    ),
                    //Icon(Icons.remove_red_eye),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún entrenamiento creado."),
      );
    }
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
                future: Hive.openBox('entrenamientos'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text(snapshot.error.toString());
                    } else {
                      return itemEntrenamientos();
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
