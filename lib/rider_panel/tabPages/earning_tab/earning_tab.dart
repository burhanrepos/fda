import 'package:fda/rider_panel/tabPages/earning_tab/widgets/earning_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../global/global.dart';

class EarningTabPage extends StatefulWidget {
    const EarningTabPage({Key? key}) : super(key: key);

  @override
  State<EarningTabPage> createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
     double _totalEarning =0;
    List earningList = [];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
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
        child: earningList.length>0?LineChart(
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
                ])
              ]),
        ):SpinKitPulse(
                            color: Colors.black,
                            size: 50.0,
                          )
      ),),
           Text(
              'Earnings History',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade300,
                    Colors.green.shade800,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rs${_totalEarning}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total Earnings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            
          ],
        ),
      ),
    );
  }
}




