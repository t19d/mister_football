import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mister_football/routes/estado_jugadores/v_estado_jugadores.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

//Almacenar el documento:
Future<void> almacenarBoxes() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(PersonAdapter());
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
  //Lugar donde se va a almacenar el documento:
  almacenarBoxes();
  runApp(MisterFootball());
}

class MisterFootball extends StatelessWidget {
  static Color primarioDark = const Color(0xFF00589b);
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
  static Color triadico2Light = const Color(0xFFd3007e);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EstadoJugadores(),
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColorDark: primarioDark,
        primaryColor: primario,
        primaryColorLight: primarioLight,
        accentColor: complementario,

        // Define the default font family.
        fontFamily: 'Georgia',
      ),
    );
  }
}
