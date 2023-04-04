import 'package:fda/rider_panel/tabPages/earning_tab/widgets/earning_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../global/global.dart';
import '../../../widgets/constants.dart';

class RiderEarningTabPage extends StatefulWidget {
    const RiderEarningTabPage({Key? key}) : super(key: key);

  @override
  State<RiderEarningTabPage> createState() => _RiderEarningTabPageState();
}

class _RiderEarningTabPageState extends State<RiderEarningTabPage> {
     double _totalEarning =0;
    List earningList = [0,0,0,0,0,0,0,0,0,0,0,0];
  @override
  initState() {
    getEarningData();
  }

  getEarningData() async {
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
       earningList = [...(yearlyEarningList as List<Object?>)];
      earningList.removeAt(0);
    }
    setState(() {});
    print("INside Earning Tab");
  print(earningList[0]);
  print(_totalEarning);
  }

  String formatNumber(double num) {
  if (num >= 1000000) {
    return '${(num/1000000).toStringAsFixed(1)}M';
  } else if (num >= 1000) {
    return '${(num/1000).toStringAsFixed(1)}k';
  } else {
    return '$num';
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Earnings')),
        automaticallyImplyLeading: false,
      ),

      body: 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              '${DateTime.now().year.toString()} Earnings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(child: Container(
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
                  FlSpot(1, double.parse(earningList[0].toString())??0),
                  FlSpot(2, double.parse(earningList[1].toString())??0),
                  FlSpot(3, double.parse(earningList[2].toString())??0),
                  FlSpot(4, double.parse(earningList[3].toString())??0),
                  FlSpot(5, double.parse(earningList[4].toString())??0),
                  FlSpot(6, double.parse(earningList[5].toString())??0),
                  FlSpot(7, double.parse(earningList[6].toString())??0),
                  FlSpot(8, double.parse(earningList[7].toString())??0),
                  FlSpot(9, double.parse(earningList[8].toString())??0),
                  FlSpot(10, double.parse(earningList[9].toString())??0),
                  FlSpot(11, double.parse(earningList[10].toString())??0),
                  FlSpot(12, double.parse(earningList[11].toString())??0)
                ],color: Constants.applicationThemeColor,
                )
              ],
              ),
        )
      ),),
            SizedBox(height: 26),
            Container(
  height: 150,
  width: MediaQuery.of(context).size.width,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.black26,
        Colors.black87,
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(0, 3),
        blurRadius: 6,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Total Earnings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Rs ${formatNumber(_totalEarning)}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
      ],
    ),
  ),
)
            
            
          ],
        ),
      ),
    );
  }
}




