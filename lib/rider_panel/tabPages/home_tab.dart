import 'package:fda/global/global.dart';
import 'package:fda/models/user_with_orders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../assistants/assistant_methods.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);
  static List allUser = [];

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.7009, 73.1040),
    zoom: 14.0,
  );
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;
  LatLng _sourceLocation = LatLng(37.4219999, -122.0840575);
  LatLng _destinationLocation = LatLng(37.42796133580664, -122.085749655962);


  StreamSubscription<Position>? streamSubscriptionPosition;
  User? get firebaseUser => currentFirebaseUser;

  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  showModelBottom() {
    return Container(
      child: Text('hello'),
    );
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
  }

  @override
  void initState() {
    super.initState();
    getAllOrders();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    final Set<Polyline> _polyline = {};
    _polyline.add(Polyline(
      polylineId: PolylineId("route1"),
      visible: true,
      width: 10,
      color: Colors.blueAccent,
      endCap: Cap.buttCap,
      points: [_sourceLocation, _destinationLocation],
    ));
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locateDriverPosition();

            //black theme google map
            blackThemeGoogleMap();
          },
          
          polylines: _polyline,
        ),
        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black87,
              )
            : Container(),

        Positioned(
          top: statusText != "Now Online"
              ? MediaQuery.of(context).size.height * 0.46
              : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isDriverActive != true) //offline
                  {
                    driverIsOnlineNow();
                    updateDriversLocation();

                    setState(() {
                      statusText = "Now Online";
                      isDriverActive = true;
                      buttonColor = Colors.transparent;
                    });

                    //display Toast
                    Fluttertoast.showToast(msg: "you are Online Now");
                  } else //online
                  {
                    driverIsOffline();

                    setState(() {
                      statusText = "Now Offline";
                      isDriverActive = false;
                      buttonColor = Colors.grey;
                    });

                    //display Toast
                    Fluttertoast.showToast(msg: "you are Offline Now");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: statusText != "Now Online"
                    ? Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.phonelink_ring,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
        statusText == "Now Online"
            ? Positioned(
                child: PopupContainer(),
                bottom: 0,
                left: 0,
                right: 0,
              )
            : Container(),

        //button
      ],
    );
  }

  getAllOrders() async {
    if (firebaseUser != null) {
      var usersDetails;
      DatabaseReference userReference =
          FirebaseDatabase.instance.ref().child("users");
      // Get the data once
      DatabaseEvent usersWithOrder = await userReference.once();
      usersDetails = usersWithOrder.snapshot.value;
      currentFirebaseUser = firebaseUser;
      for (var category in usersDetails.keys) {
        if (usersDetails[category]['orderDetails'] != null) {
          HomeTabPage.allUser.add(usersDetails[category]);
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Error while fetching data from firebase.");
    }
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideOrder");
    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateDriversLocation() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }
      LatLng latLng = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideOrder");
    ref.onDisconnect();
    ref.remove();
    ref = null;
    Future.delayed(const Duration(milliseconds: 2000), () {
      //SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      SystemNavigator.pop();
    });
  }
}

class UserOrderRequest extends StatelessWidget {
  const UserOrderRequest({
    super.key,
  });

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
          title: Text('Order Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(2.5),
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
          child: Text(
            'Name: ${userDetails['name'].toString()}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.green,
              letterSpacing: 1.0,
            ),
          ),
        ) ,
              SizedBox(height: 8.0),
              Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(2.5),
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
          child: Text(
            'Phone: ${userDetails['phone'].toString()}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.orangeAccent,
              letterSpacing: 1.0,
            ),
          ),
        ) ,
            //   Text('Phone: ${userDetails['phone'].toString()}'),
              userDetails['orderDetails'] != null
                  ? SizedBox(height: 8.0)
                  : SizedBox(),
              userDetails['orderDetails'] != null
                  ? 
                 Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(2.5),
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
          child: Text(
            'Fuel: ${userDetails['orderDetails']['Fuel'].toString()}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.redAccent,
              letterSpacing: 1.0,
            ),
          ),
        ) 
                //   Text(
                //       'Fuel: ${userDetails['orderDetails']['Fuel'].toString()}')
                  : SizedBox(),
              userDetails['orderDetails'] != null
                  ? SizedBox(height: 8.0)
                  : SizedBox(),
              userDetails['orderDetails'] != null
                  ? Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(2.5),
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
          child: Text(
            "Liter: ${userDetails['orderDetails']['Liter'].toString()}",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
              letterSpacing: 1.0,
            ),
          ),
        )
      
    //   Text(
    //                   'Liter: ${userDetails['orderDetails']['Liter'].toString()}')
                  : SizedBox(),
            userDetails['orderDetails'] != null
                ? SizedBox(height: 8.0)
                : SizedBox(),
            userDetails['orderDetails'] != null
                ? 
                Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(2.5),
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
          child: Text(
            'Price: ${userDetails['orderDetails']['Price'].toString()}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.purpleAccent,
              letterSpacing: 1.0,
            ),
          ),
        )
                // Text(
                //     'Price: ${userDetails['orderDetails']['Price'].toString()}')
                : SizedBox(),

            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    List usersRequest = HomeTabPage.allUser;

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: usersRequest.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('images/profile_icon.png')
                                    as ImageProvider),
                        SizedBox(width: 10.0),
                        Text(
                          usersRequest[index]['name'].toString(),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          //   softWrap: true,
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
                        primary: Colors.green,
                      ),
                    ),
                  ],
                );
              })),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
    );
  }
}

class PopupContainer extends StatefulWidget {
  @override
  _PopupContainerState createState() => _PopupContainerState();
}

class _PopupContainerState extends State<PopupContainer>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _isOpened = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
        parent: _animationController!, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    HomeTabPage.allUser.clear();
    super.dispose();
  }

  void _toggleContainer() {
    setState(() {
      _isOpened = !_isOpened;
      if (_isOpened) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _toggleContainer,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Orders "),
                    Text('(${HomeTabPage.allUser.length})',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
                  ],
                ),
                Icon(_isOpened
                    ? Icons.arrow_drop_down_sharp
                    : Icons.arrow_drop_up_sharp),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation!,
          child: Visibility(visible: _isOpened, child: UserOrderRequest()),
        ),
      ],
    );
  }
}
