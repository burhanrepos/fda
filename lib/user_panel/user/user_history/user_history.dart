import 'package:fda/user_panel/user/user_history/widget/user_history_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../global/global.dart';
import '../../../widgets/mydrawer.dart';


class UserHistory extends StatefulWidget {

  UserHistory();

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
    DatabaseReference completedOrderReference = FirebaseDatabase.instance
      .ref()
      .child("completedOrder");
      bool loader = false;
  List completedOrders = [];
  @override
  initState() {
    super.initState();
    getUserData();
  }
    getUserData() async {
    loader = true;
    var tempCompletedOrders;
    print("User History");
    DatabaseEvent completedOrdersEvent = await completedOrderReference.once();
    // Get the data once
    tempCompletedOrders = completedOrdersEvent.snapshot.value;
    completedOrders =[];
    for (var category in tempCompletedOrders.keys) {
        if(tempCompletedOrders[category]['id']==currentFirebaseUser!.uid){
        completedOrders.add(tempCompletedOrders[category]);
        }
      }
    print(completedOrders);
      
      setState(() {
    loader = false;
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Orders History')),
      body: loader?Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SpinKitPulse(
                  color: Colors.black,
                  size: 50.0,
                ),
              ):completedOrders.length>0?ListView.builder(
      itemCount: completedOrders.length,
      itemBuilder: (BuildContext context, int index) {
        return UserHistoryItem(order: completedOrders[index]);
      },
    ):Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey.shade500,
                  ),
                  Text(
                    'No Order to Show',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
    
  }
}
