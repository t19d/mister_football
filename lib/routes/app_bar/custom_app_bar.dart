import 'package:flutter/material.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/gestion_jugadores_edicion_creacion/v_gestion_jugadores_creacion.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> drawer;

  /*final Widget child;
  final Function onPressed;
  final Function onTitleTapped;*/

  @override
  final Size preferredSize;

  TopBar(
      {@required
          this.title,
      @required
          this.drawer /*@required this.child, @required this.onPressed, this.onTitleTapped*/
      })
      : preferredSize = Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                    1.0,
                    1.0,
                  ),
                )
              ],
              shape: BoxShape.circle,
              color: Color(0xFF3E3E3E),
            ),
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              tooltip: 'Menú',
              onPressed: () {
                drawer.currentState.openDrawer();
              },
            ), /* IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Menú',
                  onPressed: () {
                    drawer.currentState.openDrawer();
                  },*/
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 5, 0),
            width: MediaQuery.of(context).size.width / 1.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    1.0,
                    1.0,
                  ),
                )
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
                Spacer(),
                Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    splashColor: MisterFootball.complementario,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            MisterFootball.complementario,
                            MisterFootball.complementarioLight
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        child: Hero(
                          tag: 'imageHero',
                          child: IconButton(
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                            tooltip: 'Crear jugador',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GestionJugadoresCreacion(),
                                ),
                              );
                            },
                          ),

                        ),

                        /*child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GestionJugadoresCreacion(),
                                ),
                              );
                            },
                            child: IconButton(
                              icon: Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                              tooltip: 'Crear jugador',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GestionJugadoresCreacion(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),*/ /*IconButton(
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                        tooltip: 'Crear jugador',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GestionJugadoresCreacion(),
                            ),
                          );
                        },
                      ),*/
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*Hero(
                tag: 'title',
                transitionOnUserGestures: true,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: InkWell(
                    //onTap: onTitleTapped,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              // color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )*/
        ],
      ),
    );
  }
}
