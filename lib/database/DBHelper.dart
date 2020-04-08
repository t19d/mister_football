import 'dart:async';
import 'dart:io' as io;
import 'package:mister_football/clases/jugador.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String JUGADORES_ID = 'id';
  static const String JUGADORES_NOMBRE = 'nombre';
  static const String JUGADORES_APELLIDO1 = 'apellido1';
  static const String JUGADORES_APELLIDO2 = 'apellido2';
  static const String JUGADORES_APODO = 'apodo';
  static const String JUGADORES_FECHA_NACIMIENTO = 'fechaNacimiento';
  static const String JUGADORES_PIERNA_DERECHA_BUENA = 'piernaDerechaBuena';
  static const String JUGADORES_POSICION_FAVORITA = 'posicionFavorita';
  static const String JUGADORES_ANOTACIONES = 'anotaciones';
  static const String JUGADORES_NOMBRE_FOTO = 'nombre_foto';

  static const String TABLE_JUGADORES = 'Jugadores';
  static const String DB_NAME = 'mister_football.db';

  static Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TABLE_JUGADORES ($JUGADORES_ID INTEGER PRIMARY KEY AUTOINCREMENT," +
            " $JUGADORES_NOMBRE TEXT, $JUGADORES_APELLIDO1 TEXT, $JUGADORES_APELLIDO2 TEXT, $JUGADORES_APODO TEXT," +
            " $JUGADORES_FECHA_NACIMIENTO TEXT, $JUGADORES_PIERNA_DERECHA_BUENA TEXT, $JUGADORES_POSICION_FAVORITA TEXT," +
            " $JUGADORES_ANOTACIONES TEXT, $JUGADORES_NOMBRE_FOTO BLOB)");
  }

  static Future<Jugador> save(Jugador jugador) async {
    var dbClient = await db;
    jugador.id = await dbClient.insert(TABLE_JUGADORES, jugador.toMap());
    print(jugador.id);
    return jugador;
  }

  static Future<List<Jugador>> getJugadores() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE_JUGADORES, columns: [
      JUGADORES_ID,
      JUGADORES_NOMBRE,
      JUGADORES_APELLIDO1,
      JUGADORES_APELLIDO2,
      JUGADORES_APODO,
      JUGADORES_FECHA_NACIMIENTO,
      JUGADORES_PIERNA_DERECHA_BUENA,
      JUGADORES_POSICION_FAVORITA,
      JUGADORES_ANOTACIONES,
      JUGADORES_NOMBRE_FOTO
    ]);
    List<Jugador> jugadores = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        jugadores.add(Jugador.fromMap(maps[i]));
      }
    }
    return jugadores;
  }

  static Future<List<Jugador>> getJugadoresPorPosiciones() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE_JUGADORES,
        columns: [
          JUGADORES_ID,
          JUGADORES_NOMBRE,
          JUGADORES_APELLIDO1,
          JUGADORES_APELLIDO2,
          JUGADORES_APODO,
          JUGADORES_FECHA_NACIMIENTO,
          JUGADORES_PIERNA_DERECHA_BUENA,
          JUGADORES_POSICION_FAVORITA,
          JUGADORES_ANOTACIONES,
          JUGADORES_NOMBRE_FOTO
        ],
        groupBy: JUGADORES_POSICION_FAVORITA,
        orderBy: "CASE posicionFavorita " +

            "WHEN 'Portero' THEN 0 " +

            "WHEN 'Líbero' THEN 1 " +
            "WHEN 'Central' THEN 2 " +
            "WHEN 'Lateral derecho' THEN 3 " +
            "WHEN 'Lateral izquierdo' THEN 4 " +
            "WHEN 'Carrilero derecho' THEN 5 " +
            "WHEN 'Carrilero izquierdo' THEN 6 " +

            "WHEN 'Mediocentro defensivo' THEN 7 " +
            "WHEN 'Mediocentro central' THEN 8 " +
            "WHEN 'Mediocentro ofensivo' THEN 9 " +
            "WHEN 'Interior derecho' THEN 10 " +
            "WHEN 'Interior izquierdo' THEN 11 " +
            "WHEN 'Mediapunta' THEN 12 " +

            "WHEN 'Falso 9' THEN 13 " +
            "WHEN 'Segundo delantero' THEN 14 " +
            "WHEN 'Delantero centro' THEN 15 " +
            "WHEN 'Extremo derecho' THEN 16 " +
            "WHEN 'Extremo izquierdo' THEN 17 " +

            "END");
    List<Jugador> jugadores = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        jugadores.add(Jugador.fromMap(maps[i]));
      }
    }
    return jugadores;
  }

  //Elimina un jugador seleccionado.
  static Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE_JUGADORES, where: '$JUGADORES_ID = ?', whereArgs: [id]);
  }

  //Actualiza un jugador seleccionado.
  static Future<int> update(Jugador jugador) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_JUGADORES, jugador.toMap(),
        where: '$JUGADORES_ID = ?', whereArgs: [jugador.id]);
  }

  //Cierra la base de datos.
  static Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
