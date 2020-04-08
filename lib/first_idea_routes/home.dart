import 'package:flutter/material.dart';
import 'package:mister_football/first_idea_routes//sub_routes/equipo.dart';
import 'package:mister_football/first_idea_routes/sub_routes/eventos.dart';
import 'package:mister_football/first_idea_routes/sub_routes/historial.dart';
import 'package:mister_football/first_idea_routes/sub_routes/mi_perfil.dart';
import 'package:mister_football/first_idea_routes/sub_routes/ventana_pizarra.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _indiceSeleccionado = 0;

  List<Widget> _contenido = [
    Eventos(),
    Equipo(),
    VentanaPizarra(),
    Historial(),
    MiPerfil(),
  ];

  void _iconoPulsado(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            title: Text('Eventos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            title: Text('Equipo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Pizarra'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Historial'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Mi perfil'),
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
}