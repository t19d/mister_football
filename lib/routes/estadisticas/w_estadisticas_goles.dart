import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';
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

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Goles:",
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * .07),
          ),
          FutureBuilder(
            future: Hive.openBox('partidos'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Container(
                    width: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .5,
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  final boxPartidos = Hive.box('partidos');
                  for (var i = 0; i < boxPartidos.length; i++) {
                    final Partido partidoBox = boxPartidos.getAt(i) as Partido;
                    dataMap["A favor"] += partidoBox.golesAFavor.length;
                    dataMap["En contra"] += partidoBox.golesEnContra.length;
                  }
                  return PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32.0,
                    chartRadius: MediaQuery.of(context).size.width / 3,
                    showChartValuesInPercentage: false,
                    showChartValues: true,
                    showChartValuesOutside: true,
                    chartValueBackgroundColor: Colors.grey[200],
                    colorList: [Colors.lightBlueAccent, Colors.redAccent],
                    showLegends: true,
                    legendPosition: LegendPosition.right,
                    decimalPlaces: 1,
                    showChartValueLabel: true,
                    initialAngle: 0,
                    chartValueStyle: defaultChartValueStyle.copyWith(
                      color: Colors.blueGrey[900].withOpacity(0.9),
                    ),
                    chartType: ChartType.ring,
                  );
                }
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .5,
                  child: LinearProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
