import 'dart:async';
import 'package:flutter/material.dart';

class EarningTabPage extends StatefulWidget {
//   final int duration; // duration of the ride in seconds
const EarningTabPage({
    super.key,
  });

  @override
  _EarningTabPageState createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
  double _progressValue = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _progressValue += 0.1 / 1840; // update progress every second
        if (_progressValue >= 1.0) {
          _timer.cancel();
          // TODO: Add code to end the ride and show completion screen
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width * _progressValue,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(45, 56, 120, 1.0),
                  Color.fromRGBO(70, 119, 203, 1.0),
                  Color.fromRGBO(45, 56, 120, 1.0),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
