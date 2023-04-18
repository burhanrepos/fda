import 'dart:typed_data';

import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:fda/widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;
import '../../../../global/global.dart';
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
  displayUserDetails(context, userDetails) {
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
                    'Delivery Charges',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '200',
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
                //   widget.updateState();
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
   final Uint8List sourceIcon = await getBytesFromAsset('images/user-marker.png', 200);
    final Uint8List destinationIcon = await getBytesFromAsset('images/rider-marker.png', 200);


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
    RiderHomeTabPage.polyline.add(Polyline(
      polylineId: PolylineId("route1"),
      visible: true,
      width: 10,
      color: Colors.blueAccent,
      endCap: Cap.buttCap,
      points: [RiderHomeTabPage.sourceLocation, RiderHomeTabPage.destinationLocation],
    ));
    print('HOME PAGE REFERENCE');
    Navigator.of(context).pop();
    widget.updateState();
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


  addOrderToActiveOrders(userDetails) {
    userDetails['riderId'] = currentFirebaseUser!.uid;
    userDetails['orderDetails']['placed'] = true;
    userDetails['orderDetails']['accept'] = true;
    userDetails['orderDetails']['processed'] = false;
    userDetails['orderDetails']['delivered'] = false;
    userDetails['orderDetails']['completed'] = false;
    userDetails['orderDetails']['received'] = false;
    userDetails['orderDetails']['riderId'] = currentFirebaseUser!.uid;
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("activeOrders")
        .child(currentFirebaseUser!.uid);
    DatabaseReference orderRefrence =
        FirebaseDatabase.instance.ref().child("activeOrders");
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);
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
