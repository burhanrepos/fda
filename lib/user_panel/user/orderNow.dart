import 'package:fda/Widgets/progress_dialog.dart';
import 'package:fda/infoHandler/app_info.dart';
import 'package:fda/user_panel/user_mainscreen/usermain_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../global/global.dart';


class OrderNow extends StatefulWidget {
  const OrderNow({Key? key}) : super(key: key);
  
  @override
  State<OrderNow> createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {


final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
FocusNode searchFocusNode = FocusNode();
FocusNode textFieldFocusNode = FocusNode();
late SingleValueDropDownController _cnt;
late SingleValueDropDownController _secondCnt;
Position? currentPosition;
List dropDownValues = [
    {
        "fuel":"Petrol",
        "price":250,
        "color":Colors.red
    },
    {
        "fuel":"Hi-Octane",
        "price":350,
        "color":Colors.green
    },
    {
        "fuel":"Diesel",
        "price":285,
        "color":Colors.purpleAccent
    }
];

  User? get firebaseUser => currentFirebaseUser;
//late MultiValueDropDownController _cntMulti;
String _address = '';
  bool _isLoading = false;

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
        final GeolocatorPosition = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = GeolocatorPosition;
    });
    getAddressFromLatLng(currentPosition!.latitude, currentPosition!.longitude);
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }
  
  void getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _address =
              '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}';
        });
      }
    } catch (e) {
      print(e);
    }
  }


SaveOrder(){

  if(firebaseUser !=null) {
    int price=0;
    for(int index=0;index<dropDownValues.length;index++){
        if(_cnt.dropDownValue?.name.toString()==dropDownValues[index]['fuel']){
            int numberOfLiters = int.parse((_secondCnt.dropDownValue?.name.toString().substring(0,1)).toString());
            price = dropDownValues[index]['price'];
            price=price*numberOfLiters;
            print("Price =========${price}");
        }
    }
    Map userOrder={
      "id":currentFirebaseUser!.uid,
      "Fuel":_cnt.dropDownValue?.name.toString(),
      "Liter":_secondCnt.dropDownValue?.name.toString(),
      "Price":price,
      "latitude":currentPosition!.latitude,
      "longitude":currentPosition!.longitude,
      "Address":_address
    };
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
    driversRef.child(currentFirebaseUser!.uid).child("orderDetails").set(userOrder);
    currentFirebaseUser = firebaseUser;
    Fluttertoast.showToast(msg: 'Your order has been sent to rider');
    Navigator.push(context,MaterialPageRoute(builder: (c)=>UserMainScreen()));
  }
  else{
  Fluttertoast.showToast(msg: "Error to send order.");
  }
}


@override
void initState() {
  _cnt = SingleValueDropDownController();
  _secondCnt= SingleValueDropDownController();
//  _cntMulti = MultiValueDropDownController();
  super.initState();
}

@override
void dispose() {
  _cnt.dispose();
  _secondCnt.dispose();
  _secondCnt.dispose();
 // _cntMulti.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Now!'),

      ),
      body:
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Which Fuel would you like to order.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  // initialValue: "name4",
                  controller: _cnt,
                  clearOption: true,
                  // enableSearch: true,
                  // dropdownColor: Colors.green,
                  searchDecoration: const InputDecoration(
                      hintText: "Select your fuel."),
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 3,
                  dropDownList: const [
                    DropDownValueModel(name: 'Petrol',value: "value1"),
                    DropDownValueModel(
                        name: 'Hi-Octane',
                        value: "value2",
                        toolTipMsg:
                        "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: 'Diesel', value: "value3"),
                  ],
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Choose how many liters you want to order(not more than 5 liters).",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  controller: _secondCnt,
                  clearOption: true,
                  textFieldFocusNode: textFieldFocusNode,
                 // searchFocusNode: searchFocusNode,
                  // searchAutofocus: true,
                  dropDownItemCount: 5,
                  searchShowCursor: false,
                  //enableSearch: true,
                 // searchKeyboardType: TextInputType.number,
                  dropDownList: const [
                    DropDownValueModel(name: '1 Liter', value: "value1"),
                    DropDownValueModel(
                        name: '2 Liter',
                        value: "value2",
                        toolTipMsg:
                        "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: '3 Liter', value: "value3"),
                    DropDownValueModel(
                        name: '4 Liter',
                        value: "value4",
                        toolTipMsg:
                        "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: '5 Liter', value: "value5"),
                  ],
                  onChanged: (val) {},
                ),
                 const SizedBox(
                  height: 20,
                ),
                Container(
      height: 80,
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  _isLoading
                      ? CircularProgressIndicator()
                      : currentPosition != null
              ?Text(
                          _address,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
              : Container(),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(
                Icons.location_on,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _getCurrentUserLocation,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
    ),const SizedBox(
                  height: 20,
                ),
                Container(
        height: 100.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dropDownValues.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    dropDownValues[index]['fuel'].toString(),
                    style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: dropDownValues[index]['color'] ),
                  ),
                  Text(
                    dropDownValues[index]['price'].toString(),
                    style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,color: dropDownValues[index]['color']),
                  ),
                ],
              ),
            );
          },
        ),
      ),
                // const SizedBox(
                //   height: 400,
                // ),
            ],
          ),
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            print("Helkejlkrejwlrkjw");
            print(currentPosition);
            print(_cnt.dropDownValue);
            print(_secondCnt.dropDownValue);
          if(_cnt.dropDownValue == null || _secondCnt.dropDownValue == null){
            Fluttertoast.showToast(msg: "Please select value from list.");
          }
          else if (currentPosition == null){
            Fluttertoast.showToast(msg: "Please select your locaiton.");
          }
          else{
            SaveOrder();
          }
          
         const Text('your order has been confirmed');
         // Navigator.push(context, MaterialPageRoute(builder: (c)=> usermain_screen()));
        },
        label: const Text("Confirm"),
      ),
    );
  }
}