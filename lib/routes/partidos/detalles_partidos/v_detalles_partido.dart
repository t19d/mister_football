import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/sv_detalles_partido_equipo.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/sv_detalles_partido_datos.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/v_partidos_edicion.dart';
import 'package:mister_football/routes/partidos/v_partidos.dart';

class DetallesPartido extends StatefulWidget {
  final int posicion;

  DetallesPartido({Key key, @required this.posicion}) : super(key: key);

  @override
  createState() => _DetallesPartido();
}

class _DetallesPartido extends State<DetallesPartido> {
  Partido partido;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  int _indiceSeleccionado = 0;

  List<Widget> _contenido = [];

  void _iconoPulsado(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  /*@override
  void initState() {
    super.initState();
    _contenido = [
      DetallesPartidoPrepartido(
        partido: partido,
      ),
      DetallesPartidoConvocatoria(
        posicion: widget.posicion,
      ),
      DetallesPartidoAlineacion(
        posicion: widget.posicion,
      ),
      DetallesPartidoPostpartido(
        posicion: widget.posicion,
      ),
    ];
  }*/

  Future<void> _openBox() async {
    await Hive.openBox("partidos");
    await Hive.openBox("perfil");
    await Hive.openBox("jugadores");
  }

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
            final boxPartidos = Hive.box('partidos');
            partido = boxPartidos.getAt(widget.posicion);
            //Cargar el contenido de cada ventana cuando se carga el contenido del partido
            _contenido = [
              DetallesPartidoDatos(
                partido: partido,
              ),
              DetallesPartidoEquipo(
                partido: partido,
              ),
            ];
            return Scaffold(
              appBar: AppBar(
                /*title: Text(
                  "Detalles",
                ),*/
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    tooltip: 'Editar partido',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartidosEdicion(
                            posicion: widget.posicion,
                            partido: partido,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: MisterFootball.complementarioDelComplementarioLight,
                    ),
                    tooltip: 'Eliminar partido',
                    onPressed: () async {
                      Box boxEventos = await Hive.openBox('eventos');
                      Box boxPartidos = await Hive.openBox('partidos');
                      Eventos eventosActuales = boxEventos.getAt(0);
                      //Eliminar evento
                      eventosActuales.listaEventos.remove("${partido.fecha}/${partido.hora}");
                      boxEventos.putAt(0, eventosActuales);
                      boxPartidos.deleteAt(widget.posicion);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Partidos()),
                      );
                    },
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedIconTheme: IconThemeData(color: MisterFootball.primarioLight),
                showUnselectedLabels: false,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.insert_chart),
                    title: Text('Datos'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    title: Text('Equipo'),
                  ),
                ],
                currentIndex: _indiceSeleccionado,
                unselectedItemColor: const Color(0xff709392),
                selectedItemColor: const Color(0xff2a353f),
                onTap: _iconoPulsado,
                backgroundColor: Colors.white,
              ),
              body: _contenido.elementAt(_indiceSeleccionado),
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
}
