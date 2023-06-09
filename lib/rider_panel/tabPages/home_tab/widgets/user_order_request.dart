import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:fda/widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;
import '../../../../global/global.dart';
import '../../../../widgets/direction_model.dart';
import '../../../../widgets/direction_repository.dart';
import '../home_tab.dart';
class UserOrderRequest extends StatefulWidget {
//   const UserOrderRequest({
//     super.key,
//   });
  final Function() updateState;
  const UserOrderRequest({
    Key? key,
    required this.updateState,
  }) : super(key: key);

  @override
  State<UserOrderRequest> createState() => _UserOrderRequestState();
}

class _UserOrderRequestState extends State<UserOrderRequest> {
    
String _address = '';
late Directions _info;
  displayUserDetails(context, userDetails) async {
    
    LatLng destination = LatLng(
        userDetails['orderDetails']['latitude'],
        userDetails['orderDetails']['longitude']);

    var distanceFare =await calculateDistance(RiderHomeTabPage.sourceLocation,destination) as Map;
    userDetails['orderDetails']['deliveryCharges']=distanceFare['fare'];
    userDetails['orderDetails']['distance']=distanceFare['distance'];
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat"),
          title: Text(
            'Order Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${userDetails['name'].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${userDetails['phone'].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fuel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${userDetails['orderDetails']['Fuel'].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Liter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${userDetails['orderDetails']['Liter'].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${userDetails['orderDetails']['Price'].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Distance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${(distanceFare['distance'] as double).round()} km',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charges',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Rs ${distanceFare['fare']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  addOrderToActiveOrders(userDetails);
                  PopupContainer.driverWithActiveOrder = true;
                  drawPoliline(context, userDetails);
                  widget.updateState();
                },
                style: ElevatedButton.styleFrom(
                  primary: Constants.applicationThemeColor,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text("Accept order")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text("Cancel")),
          ],
        );
      },
    );
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
   }
    drawPoliline(context,userDetails)async {
        var riderDetails;
        DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(userDetails['orderDetails']['riderId']);
    DatabaseEvent driverDetailEvent = await ref.once();
    riderDetails = driverDetailEvent.snapshot.value;
   final Uint8List sourceIcon = await getBytesFromAsset('images/user-marker.png', 100);
    final Uint8List destinationIcon = await getBytesFromAsset('images/rider-marker.png', 100);


    //     BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(
    //       size: Size(10, 10)), // Customize the size of the icon as needed
    //   'images/user-marker.png', // Path to the asset image file
    // );
    // BitmapDescriptor destinationIcon = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(
    //       size: Size(10, 10)), // Customize the size of the icon as needed
    //   'images/rider-marker.png', // Path to the asset image file
    // );
    RiderHomeTabPage.destinationLocation = LatLng(
        userDetails['orderDetails']['latitude'],
        userDetails['orderDetails']['longitude']);
    print("Destination Reqeust =======${RiderHomeTabPage.destinationLocation}");
    print("Source =======${RiderHomeTabPage.sourceLocation}");
    RiderHomeTabPage.markers.clear();
    RiderHomeTabPage.polyline.clear();
    RiderHomeTabPage.markers.add(
      Marker(
        markerId: MarkerId("source"),
        position: RiderHomeTabPage.sourceLocation,
        icon: BitmapDescriptor.fromBytes(sourceIcon),
        onTap: () {
          getAddressFromLatLng(RiderHomeTabPage.sourceLocation.latitude, RiderHomeTabPage.sourceLocation.longitude);
          var imageUrl = userDetails?['imageUrl'];
          var name = userDetails['name'];
          var phone = userDetails['phone'];
          bool asset = imageUrl !=null ? false:true;
          
          showDetailOnMakers(
              'User Detail', imageUrl, name, phone, _address, asset);
        },
      ),
    );
    RiderHomeTabPage.markers.add(
      Marker(
        markerId: MarkerId("destination"),
        position: RiderHomeTabPage.destinationLocation,
        icon: BitmapDescriptor.fromBytes(destinationIcon),
        onTap: () {
          getAddressFromLatLng(RiderHomeTabPage.destinationLocation.latitude, RiderHomeTabPage.destinationLocation.longitude);
          var imageUrl = riderDetails?['imageUrl'];
          var name = riderDetails['name'];
          var phone = riderDetails['phone'];
          bool asset = imageUrl !=null ? false:true;
          
          showDetailOnMakers(
              'Rider Detail', imageUrl, name, phone, _address, asset);

        },
      ),
    );
    // RiderHomeTabPage.polyline.add(Polyline(
    //   polylineId: PolylineId("route1"),
    //   visible: true,
    //   width: 3,
    //   color: Colors.blueAccent,
    //   endCap: Cap.buttCap,
    //   points: [RiderHomeTabPage.sourceLocation, RiderHomeTabPage.destinationLocation],
    // ));
    _fetchPolylinePoints();
    print('HOME PAGE REFERENCE');
    Navigator.of(context).pop();
    // widget.updateState();
  }
  _fetchPolylinePoints() async{
    final directions = await DirectionsRepository().getDirections(origin: RiderHomeTabPage.sourceLocation, destination: RiderHomeTabPage.destinationLocation);
    // setState(() {
        print("Get the Directions===========================");
        print(directions?.polylinePoints.toString());
      
      _info = directions as Directions;
      if(_info.polylinePoints.length!=0){
        RiderHomeTabPage.polyline.add(Polyline(
      polylineId: PolylineId("route1"),
      visible: true,
      width: 3,
      color: Colors.blueAccent,
      endCap: Cap.buttCap,
      points:_info.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    ));
        
      }
    widget.updateState();

    // });
  }
  
    static Future<dynamic> calculateDistance(
      LatLng origin, LatLng destination) async {
        String _apiKey = "AIzaSyCmnV9YatIfHq_mihV0nJe6tP0Hf2CJpFc";
    final url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$_apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        final data = json.decode(response.body);
    final distanceValue = data["rows"][0]["elements"][0]["distance"]["value"];
    final distanceInKm = distanceValue / 1000.0;
    final fare = (distanceInKm * 30).round();

    final distanceFare = {"distance": distanceInKm, "fare": fare};
    return distanceFare;
    } else {
      throw Exception("Failed to calculate distance");
    }
  }

  
   showDetailOnMakers(title, imageUrl, name, phone, address, asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                asset
                    ? CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          imageUrl,
                        ),
                      ),
                SizedBox(height: 16),
                Text(
                  name, // Set user name
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  address, // Set user address
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Phone: ${phone}", // Set other user details
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  getAddressFromLatLng(double latitude, double longitude) async {
    
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
          _address = '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}';
          print("Address======${_address}");
      }
    } catch (e) {
    }
  }


  addOrderToActiveOrders(userDetails)async {
    userDetails['orderDetails']['accepted'] = true;
    String orderDate = userDetails['orderDetails']['orderDate'];
    String liter =
        userDetails['orderDetails']['Liter'].toString().substring(0, 1);
    String price = userDetails['orderDetails']['Price'].toString();
    int orderMonth = int.parse(orderDate.substring(0, 2));
    int orderYear = int.parse(orderDate.substring(6));

    DatabaseReference? userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(userDetails['orderDetails']['id']);
    userRef.set(userDetails);
    userDetails['riderId'] = currentFirebaseUser!.uid;
    userDetails['orderDetails']['placed'] = true;
    userDetails['orderDetails']['accept'] = true;
    userDetails['orderDetails']['processed'] = false;
    userDetails['orderDetails']['delivered'] = false;
    userDetails['orderDetails']['completed'] = false;
    userDetails['orderDetails']['received'] = false;
    userDetails['orderDetails']['riderId'] = currentFirebaseUser!.uid;
    userDetails['orderDetails']['userNotification'] = true;
    userDetails['orderDetails']['notificationTitle'] = "Active Order status";
    userDetails['orderDetails']['notificationDescription'] = "Your order has been confirmed.";
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("activeOrders")
        .child(currentFirebaseUser!.uid);
    DatabaseReference orderRefrence =
        FirebaseDatabase.instance.ref().child("activeOrders");
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);

    DatabaseReference? driver = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid).child('riderPurchase').child(orderYear.toString());
    DatabaseEvent driverDetailEvent = await driver.once();
      print("riderPurchaseDetails ================== ");

    var riderPurchaseDetails = driverDetailEvent.snapshot.value;
      print("riderPurchaseDetails ================== ${riderPurchaseDetails}");

    Map   tempEarningArray = {
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
    if (riderPurchaseDetails == null) {
      print("Rider Purchase SHare if================== ");
        
      for (String key in tempEarningArray.keys) {
        if (int.parse(key) == orderMonth) {
          tempEarningArray[key] = tempEarningArray[key] + (int.parse(price) - int.parse(liter) * 10);
        }
      }
      print(tempEarningArray);
      driver
          .set(tempEarningArray);
    } else {
      print("Rider Purchase SHare ELse=================");
      var companyShareList = [...((riderPurchaseDetails) as List<Object?>)];
      companyShareList.removeAt(0);
      tempEarningArray.clear(); 
      print(companyShareList);
      for (var index = 0; index < companyShareList.length; index++) {
        tempEarningArray[index + 1] = companyShareList[index];
        
        if (index + 1 == orderMonth) {
          tempEarningArray[index + 1] =
              int.parse(companyShareList[index].toString()) +
                (int.parse(price) - int.parse(liter) * 10);

        }
      }
      print(tempEarningArray);

      driver
          .set(tempEarningArray);
    }
  }

  removeOrderFromUser(userDetails) {
    print("User Details runtime type ==");
    Map<Object?, Object?> userForRemovalOrder = {
      ...userDetails
    }; // The original Map that you want to clone
    userForRemovalOrder.remove('orderDetails');
    DatabaseReference removeOrderReference =
        FirebaseDatabase.instance.ref().child("users").child(userDetails['id']);
    // removeOrderReference.set(userForRemovalOrder);
    print("User Details runtime type After==");
  }

  @override
  Widget build(BuildContext context) {
    List usersRequest = RiderHomeTabPage.allUser;

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: RiderHomeTabPage.allUser.length > 0
          ? Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: usersRequest.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            usersRequest[index]['imageUrl'] != null
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                               usersRequest[index]['imageUrl'],
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 30,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width*0.3,
                                  child: Text(
                                    usersRequest[index]['name'].toString(),
                                    maxLines: 1,
                                      overflow: TextOverflow.ellipsis, 
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    //   softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                        color: Constants.applicationThemeColor,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        usersRequest[index]['orderDetails']
                                                ['Fuel']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Constants
                                                .applicationThemeWhiteColor,
                                            backgroundColor: Constants
                                                .applicationThemeColor),
                                        //   softWrap: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                        color: Constants.applicationThemeColor,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        usersRequest[index]['orderDetails']
                                                ['Liter']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Constants
                                                .applicationThemeWhiteColor),
                                        //   softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 10.0),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            displayUserDetails(context, usersRequest[index]);
                          },
                          child: Text('Order details'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(5),
                            primary: Constants.applicationThemeColor,
                          ),
                        ),
                      ],
                    );
                  }))
          : Container(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_rounded,
                      size: 60,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      'No Order available',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
    );
  }
}
