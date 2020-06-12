import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';

class DetallesPartidoAlineacionFormacion extends StatefulWidget {
  final String formacion;
  final Partido partido;
  final String minuto;

  DetallesPartidoAlineacionFormacion({Key key, @required this.formacion, @required this.partido, @required this.minuto}) : super(key: key);

  @override
  createState() => _DetallesPartidoAlineacionFormacion();
}

Color colorear(String posicion) {
  Color coloreado = Colors.white;
  switch (posicion.toLowerCase()) {
    case "por":
    case "portero":
      coloreado = Colors.orange;
      break;
    case "def":
    case "central":
    case "líbero":
    case "lateral derecho":
    case "lateral izquierdo":
    case "carrilero derecho":
    case "carrilero izquierdo":
      coloreado = Colors.blue;
      break;
    case "med":
    case "mediocentro defensivo":
    case "mediocentro central":
    case "mediocentro ofensivo":
    case "interior derecho":
    case "interior izquierdo":
    case "mediapunta":
      coloreado = Colors.green;
      break;
    case "del":
    case "falso 9":
    case "segundo delantero":
    case "delantero centro":
    case "extremo derecho":
    case "extremo izquierdo":
      coloreado = Colors.red;
      break;
  }
  return coloreado.withOpacity(.7);
}

class _DetallesPartidoAlineacionFormacion extends State<DetallesPartidoAlineacionFormacion> {
  //Posiciones ocupadas por jugadores
  Map<String, String> posicionesOcupadas = {
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
  };

  @override
  Widget build(BuildContext context) {
    //Cargar alineación guardada
    if (widget.partido.alineacion != null) {
      if (widget.partido.alineacion['${widget.minuto}'][0] != null) {
        posicionesOcupadas = Map<String, String>.from(widget.partido.alineacion['${widget.minuto}'][1]);
        //Comprobar si los jugadores alineados están convocados.
        for (var keyPosicion in posicionesOcupadas.keys) {
          //print('$keyPosicion was written by ${posicionesOcupadas[keyPosicion]}');
          if (posicionesOcupadas[keyPosicion] != null) {
            bool _isConvocado = false;
            for (int i = 0; i < widget.partido.convocatoria.length; i++) {
              if (posicionesOcupadas[keyPosicion] == widget.partido.convocatoria[i]) {
                _isConvocado = true;
              }
            }
            if (!_isConvocado) {
              posicionesOcupadas[keyPosicion] = null;
            }
          }
        }
      }
    }
    return dibujoFormacion();
  }

  Widget dibujoFormacion() {
    Widget dibujo;
    switch (widget.formacion) {
      case "14231":
        dibujo = Dibujo14231();
        break;
      case "1442":
        dibujo = Dibujo1442();
        break;
      case "1433":
        dibujo = Dibujo1433();
        break;
      case "1451":
        dibujo = Dibujo1451();
        break;
      case "1532":
        dibujo = Dibujo1532();
        break;
      case "1523":
        dibujo = Dibujo1523();
        break;
      case "13232":
        dibujo = Dibujo13232();
        break;
      case "1352":
        dibujo = Dibujo1352();
        break;
      case "1334":
        dibujo = Dibujo1334();
        break;
    }

    return dibujo;
  }

  /*  */

  /* ALINEACIÓN */
  //CONTENIDO DEL ITEM DE CADA FILA CON EL JUGADOR SELECCIONADO
  Widget jugadorElegidoContainer(String idJugador, String posicion) {
    final boxJugadoresEquipo = Hive.box('jugadores');
    Jugador j;
    for (var i = 0; i < boxJugadoresEquipo.length; i++) {
      if ('${idJugador}' == boxJugadoresEquipo.getAt(i).id) {
        j = boxJugadoresEquipo.getAt(i);
      }
    }
    if (j != null && j is Jugador) {
      return Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 6,
          decoration: BoxDecoration(
            color: colorear(posicion),
            border: Border.all(width: .5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ConversorImagen.imageFromBase64String(j.nombre_foto, context),
              Text(j.apodo),
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 6,
          decoration: BoxDecoration(border: Border.all(width: .5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ConversorImagen.imageFromBase64String("", context),
              Text(posicion),
            ],
          ),
        ),
      );
    }
  }

/*  */
  /*----------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  ----------------------------Dibujos de formaciones----------------------------
  ------------------------------------------------------------------------------
  ----------------------------------------------------------------------------*/

  Widget Dibujo14231() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
          ],
        ),
        //Medios 2
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["9"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["8"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["4"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1442() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["8"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["4"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1433() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["8"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["4"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1451() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["9"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["8"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["4"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1532() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["8"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["5"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["4"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1523() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["8"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["5"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["4"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo13232() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
          ],
        ),
        //Medios 2
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["8"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["4"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1352() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["8"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["4"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1334() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["10"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["9"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["8"], "del"),
            jugadorElegidoContainer(posicionesOcupadas["7"], "del"),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["6"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["5"], "med"),
            jugadorElegidoContainer(posicionesOcupadas["4"], "med"),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["3"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["2"], "def"),
            jugadorElegidoContainer(posicionesOcupadas["1"], "def"),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorElegidoContainer(posicionesOcupadas["0"], "por"),
          ],
        ),
      ],
    );
  }
}
