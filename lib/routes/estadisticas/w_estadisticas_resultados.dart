import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

class EstadisticasResultados extends StatefulWidget {
  @override
  createState() => _EstadisticasResultados();
}

class _EstadisticasResultados extends State<EstadisticasResultados> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"Victorias": 0, "Empates": 0, "Derrotas": 0};
    final boxPartidos = Hive.box('partidos');
    for (var i = 0; i < boxPartidos.length; i++) {
      final Partido partidoBox = boxPartidos.getAt(i) as Partido;
      // Comprobar si es un partido ya disputado
      if (DateTime.now()
              .difference(DateTime(
                int.parse(partidoBox.fecha.split("-")[0]),
                int.parse(partidoBox.fecha.split("-")[1]),
                int.parse(partidoBox.fecha.split("-")[2]),
                //Suponiendo que los partidos duran aproximadamente 1 hora y media
                int.parse(partidoBox.hora.split(":")[0]) + 1,
                int.parse(partidoBox.hora.split(":")[1]) + 30,
              ))
              .inSeconds >
          0) {
        if (partidoBox.golesAFavor.length > partidoBox.golesEnContra.length) {
          dataMap["Victorias"]++;
        } else {
          if (partidoBox.golesAFavor.length < partidoBox.golesEnContra.length) {
            dataMap["Derrotas"]++;
          } else {
            dataMap["Empates"]++;
          }
        }
      }
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: MisterFootball.primario,
            padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
            ),
            margin: EdgeInsets.only(
              bottom: 5,
            ),
            child: Text(
              "Resultados",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * .05,
              ),
            ),
          ),
          PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width * .6,
            showChartValuesInPercentage: false,
            showChartValues: true,
            showChartValuesOutside: false,
            chartValueBackgroundColor: MisterFootball.primario.withOpacity(.8),
            chartValueStyle: defaultChartValueStyle.copyWith(
              color: Colors.white,
            ),
            colorList: [
              Colors.lightGreen,
              MisterFootball.semiprimarioLight2,
              MisterFootball.complementarioDelComplementarioLight,
            ],
            showLegends: true,
            legendPosition: LegendPosition.top,
            decimalPlaces: 0,
            showChartValueLabel: true,
            initialAngle: 3.15,
            chartType: ChartType.disc,
          ),
        ],
      ),
    );
  }
}
