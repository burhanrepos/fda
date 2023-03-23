import 'package:fda/assistants/driver_data.dart';
import 'package:fda/rider_panel/tabPages/home_tab/home_tab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../global/global.dart';
class EarningTabPage extends StatefulWidget {
  const EarningTabPage({Key? key}) : super(key: key);

  @override
  State<EarningTabPage> createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
  String riderName="Rider name";
  String userName = "your Name";
  User? get firebaseUser => currentFirebaseUser;
final auth=FirebaseAuth.instance;
final ref=FirebaseDatabase.instance.ref("users");
      var usersDetails;


 @override
  void initState() {
    getUserData();
    super.initState();
  }

    getUserData() async{
    DatabaseReference userReference = FirebaseDatabase.instance.ref("drivers").child(currentFirebaseUser!.uid);
    DatabaseEvent usersWithOrder = await userReference.once();
    usersDetails = usersWithOrder.snapshot.value;
    print("UserDetails==========");
    print(usersDetails);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Earnings'),
        leading: IconButton(icon: Icon(CupertinoIcons.back), onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder:(c)=>HomeTabPage())); },),

      ),
      body:
      SafeArea(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                    getUserData();
                },
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black26,
                backgroundImage: AssetImage("images/user-icon.png" ),
              ),
            ),
            const SizedBox(height: 10,),

            Text('Rider Name Here'),
            Divider(thickness: 1,color: Colors.black,),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Card(
                   color: Colors.white54,
                   margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                   child: ListTile(
                   leading: Icon(
                  Icons.person,
                   color: Colors.black,
                  ),
                     title: Text('Name of Rider'),

    ),

                  ),
                  const SizedBox(height: 20,),
                  Card(
                    color: Colors.white54,
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      title: Text('Email of Rider'),

                    ),

                  ),
                  Card(
                    color: Colors.white54,
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: ListTile(
                      leading: Icon(
                        Icons.bike_scooter_outlined,
                        color: Colors.black,
                      ),
                      title: Text('Bike Details'),

                    ),

                  ),
                 
    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('currentFirebaseUser', currentFirebaseUser));}
}