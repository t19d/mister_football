import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/routes/ejercicios/v_ejercicios.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'clases/partido.dart';

//Almacenar el documento:
Future<void> almacenarBoxes() async {
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  await Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(JugadorAdapter())
    ..registerAdapter(EntrenamientoAdapter())
    ..registerAdapter(PartidoAdapter())
    ..registerAdapter(EventosAdapter());
}

//Esto podría fallar
//void main() {
void main() async {
  /*SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.green.withAlpha(200),
  ));*/
  //TEST
  WidgetsFlutterBinding.ensureInitialized();
  //Orientación no girar
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  //Lugar donde se va a almacenar el documento:
  await almacenarBoxes();
  runApp(MisterFootball());
}

class MisterFootball extends StatelessWidget {
  /*static Color primarioDark = const Color(0xFF00589b);
  static Color primario = const Color(0xFF0278bd);
  static Color primarioLight = const Color(0xFF059ce5);

  static Color complementario = const Color(0xFFbd4702);
  static Color complementarioLight = const Color(0xFFd65409);

  static Color analogo1Dark = const Color(0xFF00ae91);
  static Color analogo1 = const Color(0xFF02bda4);
  static Color analogo1Light = const Color(0xFF6cd0be);

  static Color analogo2 = const Color(0xFF021bbd);
  static Color analogo2Light = const Color(0xFF3728c7);

  static Color triadico1Dark = const Color(0xFF2900b4);
  static Color triadico1 = const Color(0xFF4702bd);
  static Color triadico1Light = const Color(0xFF560dc3);

  static Color triadico2Dark = const Color(0xFF96036f);
  static Color triadico2 = const Color(0xFFbd0278);
  static Color triadico2Light = const Color(0xFFd3007e);*/

  static Color colorPrimarioDark2 = const Color(0xFF0D1624);
  static Color colorPrimarioDark = const Color(0xFF17202D);
  static Color colorPrimario = const Color(0xFF222831);
  static Color colorPrimarioLight = const Color(0xFF3F4855);
  static Color colorPrimarioLight2 = const Color(0xFF5A6473);

  static Color colorSemiprimarioDark2 = const Color(0xFF1C2026);
  static Color colorSemiprimarioDark = const Color(0xFF141B27);
  static Color colorSemiprimario = const Color(0xFF393e46);
  static Color colorSemiprimarioLight = const Color(0xFF545A64);
  static Color colorSemiprimarioLight2 = const Color(0xFF727881);

  static Color colorComplementarioDark2 = const Color(0xFF03746F);
  static Color colorComplementarioDark = const Color(0xFF0B9691);
  static Color colorComplementario = const Color(0xFF29A19C);
  static Color colorComplementarioLight = const Color(0xFF48B8B4);
  static Color colorComplementarioLight2 = const Color(0xFF77D3CF);

  static Color colorComplementarioDelComplementarioDark2 = const Color(0xFF510004);
  static Color colorComplementarioDelComplementarioDark = const Color(0xFF7B0B11);
  static Color colorComplementarioDelComplementario = const Color(0xFFa1282d);
  static Color colorComplementarioDelComplementarioLight = const Color(0xFFC1484E);
  static Color colorComplementarioDelComplementarioLight2 = const Color(0xFFEA7F84);

  static Color colorAnalogo1Dark2 = const Color(0xFF52DA80);
  static Color colorAnalogo1Dark = const Color(0xFF78EC9F);
  static Color colorAnalogo1 = const Color(0xFFa3f7bf);
  static Color colorAnalogo1Light = const Color(0xFFD5FDE3);
  static Color colorAnalogo1Light2 = const Color(0xFFFFFFFF);

  static Color colorFondo = const Color(0xFFe8e8e8);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Ejercicios(),
      /*theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: primario,
        accentColor: complementario,
        //brightness: Brightness.dark,

        // Define the default font family.
        fontFamily: 'Georgia',
        /*textTheme: GoogleFonts.tenorSansTextTheme(
          Theme.of(context).textTheme,
        ),*/
      ),*/
      theme: ThemeData(
        primaryColor: colorPrimario,
        brightness: Brightness.light,
        accentColor: colorComplementario,
        fontFamily: 'Georgia',
      ),
      /*darkTheme: ThemeData(
        primaryColor: primario,
        brightness: Brightness.dark,
        fontFamily: 'Georgia',
        accentColor: complementario,
      ),*/
    );
  }
}
