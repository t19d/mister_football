import 'package:hive/hive.dart';

part 'eventos.g.dart';

@HiveType(typeId: 3)
class Eventos {
  @HiveField(0)
  //{"2020-2-18/17:50": "Partido", }
  final Map<String, List<String>> listaEventos;

  Eventos({
    this.listaEventos,
  });
}
