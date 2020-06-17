import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/main.dart';

class DetallesEjercicioJSON extends StatefulWidget {
  final Map<String, dynamic> datos;

  DetallesEjercicioJSON({Key key, @required this.datos}) : super(key: key);

  @override
  _DetallesEjercicioJSON createState() => _DetallesEjercicioJSON();
}

class _DetallesEjercicioJSON extends State<DetallesEjercicioJSON> {
  //Estilo de los titulos de los eventos
  TextStyle tituloEventos = TextStyle(
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            /*title: Text(
            widget.datos['titulo'],
          ),*/
            ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
                decoration: BoxDecoration(
                  color: MisterFootball.primarioLight2.withOpacity(.25),
                  border: Border(bottom: BorderSide(width: 1)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //Título
                        Container(
                          width: MediaQuery.of(context).size.width * .94,
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            widget.datos['titulo'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * .05,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //Tipo
                        Text(
                          widget.datos['tipo'],
                          textAlign: TextAlign.center,
                        ),
                        //Duración
                        Text(
                          "${widget.datos['duracion']} min",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Imagen
              //Si no tiene, no mostrar
              (widget.datos['imagen'].length != 0)
                  ? Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * .03,
                        bottom: MediaQuery.of(context).size.width * .03,
                        left: MediaQuery.of(context).size.width * .03,
                        right: MediaQuery.of(context).size.width * .03,
                      ),
                      child: ConversorImagen.imageEntrenamientoFromBase64String(widget.datos['imagen'], context),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.width * .03,
                    ),
              Container(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .03,
                  right: MediaQuery.of(context).size.width * .03,
                ),
                child: Column(
                  children: <Widget>[
                    Table(
                      border: TableBorder(
                        verticalInside: BorderSide(
                          color: MisterFootball.primario,
                          width: .4,
                        ),
                      ),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        //Título
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: MisterFootball.primario, width: .4),
                              bottom: BorderSide(color: MisterFootball.primario, width: .4),
                            ),
                          ),
                          children: [
                            Text(
                              "Título",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * .03,
                                bottom: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Text(
                                "${widget.datos['titulo']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        //Tipo
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: MisterFootball.primario, width: .4),
                            ),
                          ),
                          children: [
                            Text(
                              "Tipo",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * .03,
                                bottom: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Text(
                                "${widget.datos['tipo']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        if ("${widget.datos['n_personas']}" != "-")
                        //Jugadores necesarios
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: MisterFootball.primario, width: .4),
                            ),
                          ),
                          children: [
                            Text(
                              "Jugadores necesarios",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * .03,
                                bottom: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Text(
                                "${widget.datos['n_personas']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        //Duración
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: MisterFootball.primario, width: .4),
                            ),
                          ),
                          children: [
                            Text(
                              "Duración",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * .03,
                                bottom: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Text(
                                "${widget.datos['duracion']} min",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        //Dificultad
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: MisterFootball.primario, width: .4),
                            ),
                          ),
                          children: [
                            Text(
                              "Dificultad",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * .03,
                                bottom: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Text(
                                "${widget.datos['dificultad']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        //Intensidad
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: MisterFootball.primario, width: .4),
                            ),
                          ),
                          children: [
                            Text(
                              "Intensidad",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * .03,
                                bottom: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Text(
                                "${widget.datos['intensidad']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        if ("${widget.datos['dimension_campo']}" != "-")
                          //Dimensión campo
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: MisterFootball.primario, width: .4),
                              ),
                            ),
                            children: [
                              Text(
                                "Dimensión campo",
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * .03,
                                  bottom: MediaQuery.of(context).size.width * .03,
                                ),
                                child: Text(
                                  "${widget.datos['dimension_campo']}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        if (widget.datos['elementos'].length > 0)
                          //Elementos
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: MisterFootball.primario, width: .4),
                              ),
                            ),
                            children: [
                              Text(
                                "Elementos",
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * .03,
                                  bottom: MediaQuery.of(context).size.width * .03,
                                ),
                                child: ListView(
                                  //Eliminar Scroll
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: List.generate(
                                    widget.datos['elementos'].length,
                                    (iFila) {
                                      return Text(
                                        "- ${widget.datos['elementos'][iFila]}",
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    //Descripción
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: MisterFootball.primarioLight2.withOpacity(.05),
                        border: Border(
                          top: BorderSide(width: .4),
                          bottom: BorderSide(width: .4),
                        ),
                      ),
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.width * .03,
                        top: MediaQuery.of(context).size.width * .03,
                      ),
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .03,
                        right: MediaQuery.of(context).size.width * .03,
                        bottom: MediaQuery.of(context).size.width * .015,
                        top: MediaQuery.of(context).size.width * .005,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * .025,
                            ),
                            child: Text(
                              "Descripción",
                              style: tituloEventos,
                            ),
                          ),
                          Text(
                            "${widget.datos['descripcion']}",
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
