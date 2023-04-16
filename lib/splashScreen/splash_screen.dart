import 'dart:async';

import 'package:fda/rider_panel/authentication/login_screen.dart';
import 'package:fda/rider_panel/authentication/signup_screen.dart';
import 'package:fda/global/global.dart';
import 'package:fda/rider_panel/mainScreens/main_screen.dart';
import 'package:fda/user_panel/user_mainscreen/usermain_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
        String currentUserIsDriverOrClient = "";
        
moveToSplashScreen() async{
    var ridersDetails ;
      if(await fAuth.currentUser!=null ){
        DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers");
         DatabaseEvent riderEvent = await ref.once();
      ridersDetails = riderEvent.snapshot.value;
 currentFirebaseUser = fAuth.currentUser;
      for (var rider in ridersDetails.keys) {
      print("current User is ===================${rider}");
            print("Uid=====================${currentFirebaseUser}");

        if (currentFirebaseUser?.uid == rider) {
            currentUserIsDriverOrClient = 'driver';
            print("Dirver=====================${rider}");
            break;
        }
      }
      print("current User is ===================${currentUserIsDriverOrClient}");

      }
      else{
        // Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
      print("current User is ===================${currentUserIsDriverOrClient}");

}
  startTimer(){
    Timer(const Duration(seconds:3), () async{
      if(await fAuth.currentUser!=null ){
        currentFirebaseUser=fAuth.currentUser;
        if(currentUserIsDriverOrClient=="driver"){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
        }else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=> UserMainScreen()));

        }
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
      //send user to splash screen

    });
}
@override
void dispose() {
    currentUserIsDriverOrClient="";
    super.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    moveToSplashScreen();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Material( color:Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const SizedBox(height: 100,),

              Image.asset('images/Fuel logo.png',height: 300,width: 1500,),
              const Text("Fuel Delivery App",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                fontWeight: FontWeight.bold

              )
              )
            ],
          )
        )
    );



  }
}
