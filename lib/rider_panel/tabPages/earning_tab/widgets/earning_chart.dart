import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../global/global.dart';

class EarningChart extends StatefulWidget {
  @override
  State<EarningChart> createState() => _EarningChartState();
}

class _EarningChartState extends State<EarningChart> {
    double _totalEarning =0;
    List ratingList = [];
  @override
  initState() {
    getRatingData();
  }

  getRatingData() async {
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);
    DatabaseEvent yearlyEarning =
        await  ref.child("yearlyEarning").child(DateTime.now().year.toString()).once();
    DatabaseEvent totalEarning = await ref.child("totalEarning").once();
    // Get the data once
    var yearlyEarningList = yearlyEarning.snapshot.value;
    var totalEarningValue = totalEarning.snapshot.value;
    if (yearlyEarningList != null && totalEarningValue != null) {
      _totalEarning = double.parse(totalEarningValue.toString());
       ratingList = [...(yearlyEarningList as List<Object?>)];
      ratingList.removeAt(0);
    }
    setState(() {});
  print(ratingList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 300,
        child: LineChart(
          LineChartData(
              titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                      axisNameWidget: Text(""), drawBehindEverything: true),
                  rightTitles: AxisTitles(axisNameWidget: Text(""))),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(spots: [
                  const FlSpot(1, 3),
                  const FlSpot(2, 10),
                  const FlSpot(3, 7),
                  const FlSpot(4, 12),
                  const FlSpot(5, 13),
                  const FlSpot(6, 17),
                  const FlSpot(7, 15),
                  const FlSpot(8, 20),
                  const FlSpot(9, 20),
                  const FlSpot(10, 29),
                  const FlSpot(11, 10),
                  const FlSpot(12, 6)
                ])
              ]),
        ),
      ),
    );
  }
}
