import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/detalles_partido_alineacion/w_detalles_partido_alineacion_formaciones.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/subrutas/detalles_partido_alineacion/w_partidos_alineacion_formaciones_edicion.dart';

class PartidoAlineacionCampoJugadoresEdicion extends StatefulWidget {
  final int posicion;

  //String formacionPartido;

  PartidoAlineacionCampoJugadoresEdicion({Key key, @required this.posicion /*, @required this.formacionPartido*/
      })
      : super(key: key);

  @override
  createState() => _PartidoAlineacionCampoJugadoresEdicion();
}

class _PartidoAlineacionCampoJugadoresEdicion extends State<PartidoAlineacionCampoJugadoresEdicion> {
  int columnas = 0;
  int filas = 0;
  String _formacionActual;
  List<DropdownMenuItem<String>> _formacionesDisponibles;
  List _formaciones = ["14231", "1442", "1433", "1451", "1532", "1523", "13232", "1352", "1334"];

  @override
  void initState() {
    _formacionesDisponibles = getDropDownMenuItems();
    /*Antiguo
      _formacionActual = _formacionesDisponibles[0].value;
    */
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String f in _formaciones) {
      items.add(new DropdownMenuItem(value: f, child: new Text(f)));
    }
    return items;
  }

  void cambiarFormacion(String formacionElegida) async {
    _formacionActual = formacionElegida;
  }

  void actualizarFormacionPartido(String formacionElegida) async {
    cambiarFormacion(formacionElegida);
    final boxPartidos = Hive.box('partidos');
    //Añadir lista de los jugadores convocados al partido.
    Partido partidoActual = boxPartidos.getAt(widget.posicion);
    Map<String, List> alineacionActualizada = {};
    if (partidoActual.alineacion != null) {
      alineacionActualizada = await partidoActual.alineacion;
    }
    alineacionActualizada['0'][0] = formacionElegida;
    Partido p = Partido(
        fecha: partidoActual.fecha,
        hora: partidoActual.hora,
        lugar: partidoActual.lugar,
        rival: partidoActual.rival,
        tipoPartido: partidoActual.tipoPartido,
        convocatoria: partidoActual.convocatoria,
        alineacion: alineacionActualizada,
        golesAFavor: partidoActual.golesAFavor,
        golesEnContra: partidoActual.golesEnContra,
        lesiones: partidoActual.lesiones,
        tarjetas: partidoActual.tarjetas,
        cambios: partidoActual.cambios,
        observaciones: partidoActual.observaciones,
        isLocal: partidoActual.isLocal);
    Box boxPartidosEditarAlineacion = await Hive.openBox('partidos');
    boxPartidosEditarAlineacion.putAt(widget.posicion, p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Hive.openBox('partidos'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else {
                final boxPartidos = Hive.box('partidos');
                Partido partido = boxPartidos.getAt(widget.posicion);
                //Seleccionar formación inicial
                String formacionInicialPartido = "14231";
                if (partido.alineacion != null) {
                  if (partido.alineacion['0'][0] != null) {
                    formacionInicialPartido = partido.alineacion['0'][0];
                  }
                }
                //PONER VALOR INICIAL
                //Coger el valor 0 del array del minuto 0 del mapa de la alineación =>
                //  => partidoActual.alineacion['0'][0]
                int _posicionFormacionInicial = _formaciones.indexOf(formacionInicialPartido);
                _formacionActual = _formacionesDisponibles[_posicionFormacionInicial].value;
                /*return Scaffold(
                      body: SafeArea(
                        child: DetallesPartidoAlineacionCampoJugadores(posicion: widget.posicion, formacionPartido: formacionInicialPartido),
                      ),
                    );*/
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DropdownButton(
                        value: _formacionActual,
                        items: _formacionesDisponibles,
                        onChanged: (val) async {
                          actualizarFormacionPartido(val);
                          cambiarFormacion(val);
                          setState(() {});
                        },
                      ),
                      PartidoAlineacionFormacionEdicion(posicion: widget.posicion, formacion: formacionInicialPartido),
                    ],
                  ),
                );
              }
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: LinearProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
