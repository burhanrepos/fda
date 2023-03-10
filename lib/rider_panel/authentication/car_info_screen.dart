import 'package:fda/global/global.dart';
import 'package:fda/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController bikeMakeTextEditingController=TextEditingController();
  TextEditingController bikeNumberTextEditingController=TextEditingController();
  TextEditingController bikeModelTextEditingController=TextEditingController();

  saveCarInfo(){
    Map driverCarInfoMap =
    {
      "bike_make": bikeMakeTextEditingController.text.trim(),
      "bike_number": bikeNumberTextEditingController.text.trim(),
      "bike_model":bikeModelTextEditingController.text.trim(),
    };
    DatabaseReference driversRef =FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("bike_details").set(driverCarInfoMap);
    Fluttertoast.showToast(msg: "Bike details has been saved.");
    Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
        const SizedBox(height: 24,),
    Padding(padding: const EdgeInsets.all(10.0),
    child: Image.asset("images/bike.jpg"),
    ),
          const SizedBox(height: 50,),
          const Text("Rider Vehical details",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          TextField(
            controller: bikeMakeTextEditingController,
            style: const TextStyle(
              color: Colors.white,

            ),
            decoration: const InputDecoration(
              labelText: "Make",
              hintText: "Make",
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
            controller: bikeModelTextEditingController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.white,

            ),
            decoration: const InputDecoration(
              labelText: "Model",
              hintText: "Model",
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
            controller: bikeNumberTextEditingController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.white,

            ),
            decoration: const InputDecoration(
              labelText: "Bike No.",
              hintText: "Bike No.",
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
              if(bikeMakeTextEditingController.text.isNotEmpty&&
              bikeNumberTextEditingController.text.isNotEmpty
              && bikeModelTextEditingController.text.isNotEmpty != null){
                saveCarInfo();

              }


            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreenAccent,
            ),
            child:const Text(
              "Save Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,


              ),
            ),
          ),

          ],
        ),
      ),
    ),
    );
  }
}
