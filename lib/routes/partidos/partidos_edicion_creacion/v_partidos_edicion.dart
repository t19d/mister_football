import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/detalles_partido_alineacion/sv_detalles_partido_alineacion.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/sv_detalles_partido_convocatoria.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/sv_detalles_partido_postpartido.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/sv_detalles_partido_prepartido.dart';
import 'package:mister_football/routes/partidos/v_partidos.dart';

class PartidosEdicion extends StatefulWidget {
  final int posicion;

  PartidosEdicion({Key key, @required this.posicion}) : super(key: key);

  @override
  createState() => _PartidosEdicion();
}

class _PartidosEdicion extends State<PartidosEdicion> {
  Partido partido = null;

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

  @override
  void initState() {
    super.initState();
    _contenido = [
      DetallesPartidoPrepartido(
        posicion: widget.posicion,
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('partidos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxPartidos = Hive.box('partidos');
            partido = boxPartidos.getAt(widget.posicion);
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Detalles",
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    tooltip: 'Eliminar jugador',
                    onPressed: () async {
                      var boxPartidos = await Hive.openBox('partidos');
                      var boxEventos = await Hive.openBox('eventos');
                      Eventos eventosActuales = boxEventos.get(0);
                      //Eliminar evento
                      eventosActuales.listaEventos.remove("${partido.fecha}/${partido.hora}");
                      boxPartidos.deleteAt(widget.posicion);
                      boxEventos.putAt(0, eventosActuales);
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
                    icon: Icon(Icons.featured_play_list),
                    title: Text('Prepartido'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.filter_frames),
                    title: Text('Convocatoria'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    title: Text('Alineación' /*\ninicial', textAlign: TextAlign.center,*/),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.insert_chart),
                    title: Text('Postpartido'),
                  ),
                ],
                currentIndex: _indiceSeleccionado,
                unselectedItemColor: const Color(0xff709392),
                selectedItemColor: const Color(0xff2a353f),
                onTap: _iconoPulsado,
                backgroundColor: Colors.white,
              ),
              body: Center(
                child: _contenido.elementAt(_indiceSeleccionado),
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
}