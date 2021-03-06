import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/alineacion_favorita/v_alineacion.dart';
import 'package:mister_football/routes/configuracion/v_configuracion.dart';
import 'package:mister_football/routes/ejercicios/v_ejercicios.dart';
import 'package:mister_football/routes/entrenamientos/v_entrenamientos.dart';
import 'package:mister_football/routes/equipo/v_equipo.dart';
import 'package:mister_football/routes/estadisticas/v_estadisticas.dart';
import 'package:mister_football/routes/estado_jugadores/v_estado_jugadores.dart';
import 'package:mister_football/routes/eventos/v_eventos.dart';
import 'package:mister_football/routes/gestion_jugadores/v_gestion_jugadores.dart';
import 'package:mister_football/routes/partidos/v_partidos.dart';
import 'package:mister_football/routes/perfil/v_perfil.dart';
import 'package:mister_football/routes/resultados/v_resultados.dart';

class Navegador extends StatefulWidget {
  Navegador({Key key}) : super(key: key);

  @override
  _Navegador createState() => _Navegador();
}

class _Navegador extends State<Navegador> {
  //Estilo de los enlaces
  TextStyle estiloEnlaces = TextStyle(color: Colors.white);

  //Divisores
  Divider divisor = Divider(
    color: Colors.white70,
  );

  //Devuelve encabezado del navigator
  Widget devolverEncabezado() {
    final boxPerfil = Hive.box('perfil');
    Map<String, dynamic> equipo = {};
    if (boxPerfil.get(0) != null) {
      equipo = Map.from(boxPerfil.get(0));
      return Container(
        padding: EdgeInsets.fromLTRB(
          (MediaQuery.of(context).size.width * .05),
          (MediaQuery.of(context).size.width * .025),
          (MediaQuery.of(context).size.width * .05),
          0,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          //Cambiar por el escudo del equipo (si el usuario quiere)
          (equipo['escudo'] != null)
              ? ((equipo['escudo'].length == 0)
                  ? ConversorImagen.devolverEscudoNavegadorImageFromBase64String("", context)
                  : ConversorImagen.devolverEscudoNavegadorImageFromBase64String(equipo['escudo'], context))
              : ConversorImagen.devolverEscudoNavegadorImageFromBase64String("", context),
          Text(
            (equipo['nombre_equipo'] != null) ? ((equipo['nombre_equipo'].length == 0) ? "Equipo" : equipo['nombre_equipo']) : "Equipo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (MediaQuery.of(context).size.width * .05),
              color: Colors.white,
              height: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(
          (MediaQuery.of(context).size.width * .05),
          (MediaQuery.of(context).size.width * .025),
          (MediaQuery.of(context).size.width * .05),
          0,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          ConversorImagen.devolverEscudoNavegadorImageFromBase64String("", context),
          Text(
            "Equipo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (MediaQuery.of(context).size.width * .05),
              color: Colors.white,
              height: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [MisterFootball.colorPrimario, MisterFootball.colorPrimarioDark]),
      ),
      child: ListView(
        children: <Widget>[
          //T??tulo equipo
          FutureBuilder(
            future: Hive.openBox('perfil'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text(snapshot.error.toString());
                } else {
                  return devolverEncabezado();
                }
              } else {
                return Container(
                  padding: EdgeInsets.fromLTRB(
                    (MediaQuery.of(context).size.width * .05),
                    (MediaQuery.of(context).size.width * .025),
                    (MediaQuery.of(context).size.width * .05),
                    0,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      (MediaQuery.of(context).size.width * .05),
                      (MediaQuery.of(context).size.width * .025),
                      (MediaQuery.of(context).size.width * .05),
                      0,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                      ConversorImagen.devolverEscudoNavegadorImageFromBase64String("", context),
                      Text(
                        "Equipo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (MediaQuery.of(context).size.width * .05),
                          color: Colors.white70,
                          height: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                );
              }
            },
          ),
          divisor,
          //Item Jugadores
          ListTile(
            title: Text(
              "Jugadores",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.directions_run,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GestionJugadores()),
              );
            },
          ),
          divisor,
          //Item Partidos
          ListTile(
            title: Text(
              "Partidos",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.trending_up,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Partidos()),
              );
            },
          ),
          //Item Resultados
          /*ListTile(
            title: Text(
              "Resultados",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.insert_chart,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Resultados()),
              );
            },
          ),*/
          divisor,
          //Item Entrenamientos
          ListTile(
            title: Text(
              "Entrenamientos",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.filter_frames,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Entrenamientos()),
              );
            },
          ),
          //Item Ejercicios
          ListTile(
            title: Text(
              "Ejercicios",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.fitness_center,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Ejercicios()),
              );
            },
          ),
          divisor,
          //Item Estado Jugadores
          /*ListTile(
            title: Text(
              "Estado jugadores",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.playlist_add_check,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EstadoJugadores()),
              );
            },
          ),*/
          //Item Alineaci??n Favorita
          ListTile(
            title: Text(
              "Alineaci??n favorita",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.people,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Alineacion()),
              );
            },
          ),
          //Item Estad??sticas
          ListTile(
            title: Text(
              "Estad??sticas",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.insert_chart,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Estadisticas()),
              );
            },
          ),
          //Item Detalles Equipo
          /*ListTile(
            title: Text(
              "Equipo",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.people,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Equipo()),
              );
            },
          ),*/
          //Item Eventos
          ListTile(
            title: Text(
              "Eventos",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.event_note,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VentanaEventos()),
              );
            },
          ),
          divisor,
          //Item Perfil
          /*ListTile(
            title: Text(
              "Perfil",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.person,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Perfil()),
              );
            },
          ),*/
          //Item Configuraci??n
          ListTile(
            title: Text(
              "Configuraci??n",
              style: estiloEnlaces,
            ),
            leading: Icon(
              Icons.settings,
              color: Colors.white70,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Configuracion()),
              );
            },
          ),
        ],
      ),
    );
  }
}
