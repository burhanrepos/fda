import 'package:fda/Widgets/progress_dialog.dart';
import 'package:fda/infoHandler/app_info.dart';
import 'package:fda/user_mainscreen/usermain_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';


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

  User? get firebaseUser => currentFirebaseUser;
//late MultiValueDropDownController _cntMulti;

SaveOrder(){

  if(firebaseUser !=null) {
    Map userOrder={
      "id":currentFirebaseUser!.uid,
      "Fuel":_cnt.dropDownValue.toString(),
      "Liter":_secondCnt.dropDownValue.toString(),
    };
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
    driversRef.child(currentFirebaseUser!.uid).child("Order details").set(userOrder);
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
                  height: 400,
                ),
            ],
          ),
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if(_cnt.dropDownValue.toString().isEmpty && _secondCnt.dropDownValue.toString().isEmpty !=null){
            Fluttertoast.showToast(msg: "Please select value from list.");
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