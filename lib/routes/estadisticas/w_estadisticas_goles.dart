import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

class EstadisticasGoles extends StatefulWidget {
  @override
  createState() => _EstadisticasGoles();
}

class _EstadisticasGoles extends State<EstadisticasGoles> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"A favor": 0, "En contra": 0};
    final boxPartidos = Hive.box('partidos');
    for (var i = 0; i < boxPartidos.length; i++) {
      final Partido partidoBox = boxPartidos.getAt(i) as Partido;
      dataMap["A favor"] += partidoBox.golesAFavor.length;
      dataMap["En contra"] += partidoBox.golesEnContra.length;
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
            margin:  EdgeInsets.only(
              bottom: 5,
            ),
            child: Text(
              "Goles",
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
              MisterFootball.primarioLight2,
              MisterFootball.complementarioDelComplementarioLight,
            ],
            showLegends: true,
            legendPosition: LegendPosition.top,
            decimalPlaces: 0,
            showChartValueLabel: true,
            initialAngle: 3.14,
            chartType: ChartType.disc,
          ),
        ],
      ),
    );
  }
}
