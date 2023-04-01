


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../global/global.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  _RatingsTabPageState createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  int oneStarCount = 0;
  int twoStarCount = 0;
  int threeStarCount = 0;
  int fourStarCount = 0;
  int fiveStarCount = 0;
  double _rating = 0;

  @override
  initState() {
    getRatingData();
  }

  getRatingData() async {
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);
    // Get the data once
    DatabaseEvent ratingList = await ref.child("rating").once();
    DatabaseEvent overallRating = await ref.child("totalRating").once();
    var ratingDetail = ratingList.snapshot.value;
    var overAllRatingValue = overallRating.snapshot.value;
    if (ratingDetail != null && overAllRatingValue != null) {
      _rating = double.parse(overAllRatingValue.toString());
      var ratingList = [...(ratingDetail as List<Object?>)];
      ratingList.removeAt(0);
      oneStarCount = int.parse(ratingList[0].toString());
      twoStarCount = int.parse(ratingList[1].toString());
      threeStarCount = int.parse(ratingList[2].toString());
      fourStarCount = int.parse(ratingList[3].toString());
      fiveStarCount = int.parse(ratingList[4].toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Center(child: Text('Ratings')),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Your overall rating',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20.0),
                          _buildRatingBar(5, fiveStarCount),
                          SizedBox(height: 20.0),
                          _buildRatingBar(4, fourStarCount),
                          SizedBox(height: 20.0),
                          _buildRatingBar(3, threeStarCount),
                          SizedBox(height: 20.0),
                          _buildRatingBar(2, twoStarCount),
                          SizedBox(height: 20.0),
                          _buildRatingBar(1, oneStarCount),
                          SizedBox(height: 20.0),
                          SizedBox(height: 20.0),
                          SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric( vertical: 10.0),
                                child: Text(
                                  'Star Rating',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                tapOnlyMode: true,
                                ignoreGestures: true,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(int rating, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                  '$rating',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            flex: 7,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.0,
                    width: 10.0 * count.toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _incrementCount(int rating) {
    setState(() {
      switch (rating) {
        case 1:
          oneStarCount++;
          break;
        case 2:
          twoStarCount++;
          break;
        case 3:
          threeStarCount++;
          break;
        case 4:
          fourStarCount++;
          break;
        case 5:
          fiveStarCount++;
          break;
      }
    });
  }
}
