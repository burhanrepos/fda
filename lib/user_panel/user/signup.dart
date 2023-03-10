import 'package:fda/Widgets/progress_dialog.dart';
import 'package:fda/rider_panel/authentication/car_info_screen.dart';
import 'package:fda/rider_panel/authentication/login_screen.dart';
import 'package:fda/splashScreen/usersplash_screen.dart';
import 'package:fda/user_panel/user/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../global/global.dart';
import '../../splashScreen/splash_screen.dart';
class UserSignupScreen extends StatefulWidget {
  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  TextEditingController nameTextEditingController=TextEditingController();
  TextEditingController emailTextEditingController=TextEditingController();
  TextEditingController phoneTextEditingController=TextEditingController();
  TextEditingController passwordTextEditingController=TextEditingController();


  ValidateForm(){
    if(nameTextEditingController.text.length<3){
      Fluttertoast.showToast(msg: "Name must be 3 characters.");
    }
    else if(!emailTextEditingController.text.contains("@")){
      Fluttertoast.showToast(msg: "Email is not valid.");
    }
    else if (phoneTextEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Phone is not mandatory.");
    }
    else if(passwordTextEditingController.text.length<6){
      Fluttertoast.showToast(msg: "Password should be 6 character long.");
    }
    else
    {
      saveUserInfo();
    }

  }
  saveUserInfo() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message:"Please wait.....",);
        }
    );
    final User? firebaseUser=(
        await fAuth.createUserWithEmailAndPassword(
          email:emailTextEditingController.text.trim(),
          password:passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg:"Error:"+msg.toString());

        } )
    ).user;
    if(firebaseUser!=null)
    {
      Map usersMap =
      {
        "id": firebaseUser.uid,
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "phone":phoneTextEditingController.text.trim(),
      };
      DatabaseReference driversRef =FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).set(usersMap);
      currentFirebaseUser=firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created.");
      Navigator.push(context,MaterialPageRoute(builder: (c)=>UserSplashScreen()));
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created.");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.all(10.0),
              child: Image.asset("images/bike.jpg"),



            ),
            const SizedBox(height: 50,),
            const Text("Register as User",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: nameTextEditingController,
              style: const TextStyle(
                color: Colors.white,

              ),
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Name",
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
              controller: phoneTextEditingController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Colors.white,

              ),
              decoration: const InputDecoration(
                labelText: "Phone No.",
                hintText: "Phone No.",
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
                //Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));

              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreenAccent,
              ),
              child:const Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,


                ),
              ),
            ),

            TextButton(
              child: const Text(
                "Already have an account? Login here.",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: ()
              {
                Navigator.push(context,MaterialPageRoute(builder:(c)=>UserLoginScreen()));

              },
            ),


          ],
        ),
      ),

    );

  }
}
