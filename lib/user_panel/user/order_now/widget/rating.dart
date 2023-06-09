import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../global/global.dart';
import '../../../../widgets/constants.dart';
import '../../../user_mainscreen/usermain_screen.dart';

class UserRating extends StatefulWidget {
  final Function() updateState;

  UserRating({required this.updateState});
  @override
  _UserRatingState createState() => _UserRatingState();
}

class _UserRatingState extends State<UserRating> {
  double _rating = 0.0;

  DatabaseReference orderRefrence =
      FirebaseDatabase.instance.ref().child("activeOrders");
  orderCompleted(userDetails) {
    userDetails['orderDetails']['received'] = true;
    userDetails['orderDetails']['riderNotification'] = true;
    userDetails['orderDetails']['notificationTitle'] = "Active Order status";
    userDetails['orderDetails']['notificationDescription'] =
        "You have completed your order";
    orderRefrence.child(userDetails['riderId']).set(userDetails);
    dispose();
    widget.updateState();
  }

  void _submitRating() {
    addEarningOfRider(UserMainScreen.activeOrderDetails);
    updateTheRatingInUser(UserMainScreen.activeOrderDetails);
    orderCompleted(UserMainScreen.activeOrderDetails);
    Navigator.pop(context);
  }

  void addEarningOfRider(activeOrderDetails) async {
    String orderDate = activeOrderDetails['orderDetails']['orderDate'];
    String price = activeOrderDetails['orderDetails']['Price'].toString();
    String liter =
        activeOrderDetails['orderDetails']['Liter'].toString().substring(0, 1);
    String deliveryCharges =
        activeOrderDetails['orderDetails']['deliveryCharges'].toString();
    int orderMonth = int.parse(orderDate.substring(0, 2));
    int orderDateInMonth = int.parse(orderDate.substring(3, 5));
    int orderYear = int.parse(orderDate.substring(6));

    Map tempEarningArray = {
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0
    };
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(activeOrderDetails['orderDetails']['riderId']);
    // Get the data once
    DatabaseEvent yearlyEarning =
        await ref.child("yearlyEarning").child(orderYear.toString()).once();
    DatabaseEvent companyShare =
        await ref.child("companyShare").child(orderYear.toString()).once();
    var companyShareDetails = companyShare.snapshot.value;

    var earningDetails = yearlyEarning.snapshot.value;
    if (earningDetails == null) {
      for (String key in tempEarningArray.keys) {
        if (int.parse(key) == orderMonth) {
          tempEarningArray[key] =
              tempEarningArray[key] + (deliveryCharges as double);
        }
      }
      var totalEarning = 0;
      for (int value in tempEarningArray.values) {
        totalEarning += value;
      }
      ref
          .child("yearlyEarning")
          .child(orderYear.toString())
          .set(tempEarningArray);
      ref.child("totalEarning").set(totalEarning);
    } else {
      var earningList = [...(earningDetails as List<Object?>)];
      earningList.removeAt(0);
      tempEarningArray.clear();
      for (var index = 0; index < earningList.length; index++) {
        tempEarningArray[index + 1] = earningList[index];
        if (index + 1 == orderMonth) {
          tempEarningArray[index + 1] =
              int.parse(earningList[index].toString()) +
                  int.parse(deliveryCharges);
        }
      }
      var totalEarning = 0;
      for (int value in tempEarningArray.values) {
        totalEarning += value;
      }
      ref
          .child("yearlyEarning")
          .child(orderYear.toString())
          .set(tempEarningArray);
      ref.child("totalEarning").set(totalEarning);
    }
    tempEarningArray = {
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0
    };
    if (companyShareDetails == null) {
      print("COmparny SHare IF==================");
      for (String key in tempEarningArray.keys) {
        if (int.parse(key) == orderMonth) {
          tempEarningArray[key] = tempEarningArray[key] + int.parse(liter) * 10;
        }
      }
      print(tempEarningArray);
      ref
          .child("companyShare")
          .child(orderYear.toString())
          .set(tempEarningArray);
    } else {
      print("COmparny SHare ELse==================");
      var companyShareList = [...((companyShareDetails) as List<Object?>)];
      companyShareList.removeAt(0);
      tempEarningArray.clear();
      for (var index = 0; index < companyShareList.length; index++) {
        tempEarningArray[index + 1] = companyShareList[index];
        if (index + 1 == orderMonth) {
          tempEarningArray[index + 1] =
              int.parse(companyShareList[index].toString()) +
                  (int.parse(liter) * 10);
        }
      }
      print(tempEarningArray);

      ref
          .child("companyShare")
          .child(orderYear.toString())
          .set(tempEarningArray);
    }
  }

  updateTheRatingInUser(userDetails) async {
    Map tempRatingArray = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0};
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(userDetails['orderDetails']['riderId']);
    // Get the data once
    DatabaseEvent usersWithOrder = await ref.child("rating").once();
    var ratingDetail = usersWithOrder.snapshot.value;
    if (ratingDetail == null) {
      for (String key in tempRatingArray.keys) {
        if (int.parse(key) == _rating.floor()) {
          tempRatingArray[key] = 1;
        }
      }
      var totalCountRating = 0;
      int totalCummulativeRating = 0;
      int counter = 1;
      for (int value in tempRatingArray.values) {
        totalCummulativeRating += counter * value;
        totalCountRating += value;
        counter++;
      }
      double finalRating = totalCummulativeRating / totalCountRating;
      ref.child("totalRating").set(finalRating);
      ref.child("rating").set(tempRatingArray);
    } else {
      var ratingList = [...(ratingDetail as List<Object?>)];
      ratingList.removeAt(0);
      tempRatingArray.clear();
      for (var index = 0; index < ratingList.length; index++) {
        tempRatingArray[index + 1] = ratingList[index];
        if (index == _rating - 1) {
          tempRatingArray[index + 1] =
              int.parse(ratingList[index].toString()) + 1;
        }
      }
      var totalCountRating = 0;
      int totalCummulativeRating = 0;
      int counter = 1;
      for (int value in tempRatingArray.values) {
        totalCummulativeRating += counter * value;
        totalCountRating += value;
        counter++;
      }
      double finalRating = totalCummulativeRating / totalCountRating;
      ref.child("totalRating").set(finalRating);
      ref.child("rating").set(tempRatingArray);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Center(
          child: Text(
        'Rate this order',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'How would you rate your experience with this rider?',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 18.0),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Constants.applicationThemeColor,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Submit',
            style: TextStyle(
                color: _rating == 0
                    ? Colors.grey
                    : Constants.applicationThemeColor,
                fontSize: 16),
          ),
          onPressed: () {
            color:
            _rating != 0 ? _submitRating() : '';
          },
        ),
      ],
    );
  }
}
