import 'package:fda/Widgets/progress_dialog.dart';
import 'package:fda/rider_panel/authentication/car_info_screen.dart';
import 'package:fda/rider_panel/authentication/login_screen.dart';
import 'package:fda/user_panel/user/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../global/global.dart';
import '../../splashScreen/splash_screen.dart';
import '../../splashScreen/usersplash_screen.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  TextEditingController emailTextEditingController=TextEditingController();
  TextEditingController passwordTextEditingController=TextEditingController();

  ValidateForm(){

    if(!emailTextEditingController.text.contains("@")){
      Fluttertoast.showToast(msg: "Email is not valid.");
    }

    else if(passwordTextEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Password is required.");
    }
    else
    {
      loginDriverNow();

    }

  }
  loginDriverNow() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message:"Please wait.....",);
        }
    );
    final User? firebaseUser=(
        await fAuth.signInWithEmailAndPassword(
          email:emailTextEditingController.text.trim(),
          password:passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg:"Error:"+msg.toString());

        } )
    ).user;
    if(firebaseUser!=null)
    {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey)
      {
        final snap = driverKey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const UserSplashScreen()));
        }
        else
        {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error occur during login.");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Padding(padding: const EdgeInsets.all(10.0),
                child: Image.asset("images/bike.jpg"),
              ),
              const SizedBox(height: 50,),
              const Text("Login as User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                style: const TextStyle(
                  color: Colors.white,

                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,

                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  ValidateForm();
                  // Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child:const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,


                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Don't have an account? Signup here.",
                  style: TextStyle(color: Colors.white),

                ),

                onPressed: ()
                {
                  Navigator.push(context,MaterialPageRoute(builder:(c)=>UserSignupScreen()));

                },
              ),
             /* TextButton(
                child: const Text(
                  "Continue as User.",
                  style: TextStyle(color: Colors.white),

                ),

                onPressed: ()
                {
                  Navigator.push(context,MaterialPageRoute(builder:(c)=>UserSignupScreen()));

                },
              ),*/

            ],

          ),
        ),

      ),

    );
  }
}

