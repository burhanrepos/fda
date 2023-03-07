import 'dart:async';
import 'package:fda/assistants/assistant_methods.dart';
import 'package:fda/authentication/login_screen.dart';
import 'package:fda/authentication/signup_screen.dart';
import 'package:fda/global/global.dart';
import 'package:fda/mainScreens/main_screen.dart';
import 'package:fda/user_mainscreen/usermain_screen.dart';
import 'package:flutter/material.dart';
class UserSplashScreen extends StatefulWidget {
  const UserSplashScreen({Key? key}) : super(key: key);

  @override
  State<UserSplashScreen> createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  startTimer(){
    fAuth.currentUser!= null ? AssistantMethods.readCurrentOnlineUserInfo()  : null ;
    Timer(const Duration(seconds:2), () async{
      if(await fAuth.currentUser!=null ){
        currentFirebaseUser=fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> UserMainScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
      //send user to splash screen

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
