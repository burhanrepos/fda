import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fda/global/global.dart';
// import 'package:fda/models/directions.dart';
import '../../widgets/direction_model.dart';
import 'package:fda/user_panel/user/order_now/orderNow.dart';
import 'package:fda/user_panel/user/order_now/widget/user_order_progress.dart';
import 'package:fda/widgets/direction_repository.dart';
import 'package:fda/widgets/divider.dart';
import 'package:fda/widgets/mydrawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:fda/user/login.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../assistants/assistant_methods.dart';
import '../../assistants/geofire_assistant.dart';
import 'package:fda/models/active_nearby_available_drivers.dart';


import 'package:awesome_notifications/awesome_notifications.dart';

import '../user/order_now/widget/user_order_placed.dart';

//import '../mainScreens/searchScreen.dart';
//import '../models/active_nearby_available_drivers.dart';
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});
  static Map<Object?, Object?>? allActiveOrders;
  static String idOfActiveOrderRider = "";
  static var activeOrderDetails;
  static var OrderDetailsOfCurrentUser = null;
  static var OrderDetailsOfCurrenRider = null;
  static Set<Polyline> polyline = {};
  static Set<Marker> markers = {};
  static LatLng sourceLocation = LatLng(37.4219999, -122.0840575);
  static LatLng destinationLocation =
      LatLng(37.42796133580664, -122.085749655962);

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

/*class _UserMainScreenState extends State<UserMainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController?newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );
  static final CameraPosition _Klake= CameraPosition(
    target: LatLng(33.567997728,72.635997456),
  zoom: 14,
  );

  final List<Marker> _markers = <Marker>[
    Marker(
    markerId: MarkerId('1'),
    position: LatLng (33.6844,73.0479),
    infoWindow: InfoWindow(
      title: 'the title of marker'
    )
    )
  ];

  final Set<Marker> _marks= {};
  final Set<Polyline>_polyline={};

  List<LatLng>latlng=[
    LatLng(33.6844,73.0479),
    LatLng(33.567997728,72.635997456)
  ];

@override
  void initState(){
    super.initState();

    for(int i = 0; i<latlng.length; i++){
      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: latlng [i],
            infoWindow: InfoWindow(
                title: 'the title of marker',
              snippet: '5 stars',
            ),
          icon: BitmapDescriptor.defaultMarker,
        )
        );
      setState(() {

      });
      _polyline.add(
        Polyline(polylineId: PolylineId('1'),
        points: latlng,
          color: Colors.orange,
        ),
      );

    }


  }

  Future<Position> getUserCurrentLocation()async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace){
      print("error"+error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }


  @override
  Widget build(BuildContext context)
  {
     return Scaffold(
       body: Stack(
         children: [
           GoogleMap(
             mapType: MapType.normal,
             myLocationEnabled: true,
             polylines: _polyline,
             initialCameraPosition: _kGooglePlex,
             markers: Set<Marker>.of(_markers),
             compassEnabled: true,
             onMapCreated: (GoogleMapController controller)
             {
               _controllerGoogleMap.complete(controller);
               newGoogleMapController= controller;


             },
           ),

           FloatingActionButton(onPressed: ()async{
             floatingActionButton: FloatingActionButton.extended;
             label: Text('To the lake'),
             getUserCurrentLocation().then((value)async{

               print('my current location');
               print("${value.latitude} ${value.longitude}");

               _markers.add(
                   Marker(
                       markerId: MarkerId('2'),
                       position: LatLng (value.latitude , value.longitude),
                       infoWindow: InfoWindow(
                           title: 'my current location'
                       )
                   )
               );
               CameraPosition cameraPosition = CameraPosition(
                 zoom: 14,
                   target: LatLng(value.latitude,value.longitude));

               var _controller;
               final GoogleMapController controller = await _controller.future;
               controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
               setState(() {

               });

             });



           },

             child: Icon(Icons.add_location),



           ),

         ],
       ),
     );
  }
} */

class _UserMainScreenState extends State<UserMainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseReference orderRefrence =
      FirebaseDatabase.instance.ref().child("activeOrders");

  // late Position currentPosition;
  // var geoLocator= Geolocator();
  //double bottomPadding=0;
  // Position? userCurrentPosition;

  //yeh new wala ha
  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail = "your Email";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;
  Timer? timer;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void locatePosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  getAllActiveOrders() async {
    var activeOrders = null;
    var driverDetails;
    var userDetails;
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child("activeOrders");
    DatabaseReference currentUserReference = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    // Get the data once
    DatabaseEvent usersWithOrder = await userReference.once();
    DatabaseEvent currentUserEvent = await currentUserReference.once();
    activeOrders = usersWithOrder.snapshot.value;
    // UserMainScreen.OrderDetailsOfCurrentUser = currentUserEvent.snapshot.value;
    userDetails = currentUserEvent.snapshot.value;
    if (userDetails['orderDetails'] != null)
      UserMainScreen.OrderDetailsOfCurrentUser = userDetails;
    else
      UserMainScreen.OrderDetailsOfCurrentUser = null;
    print("Current User Order Details======${userDetails['orderDetails']}");
    if (activeOrders != null) {
      for (var category in activeOrders?.keys) {
        if (activeOrders[category]['orderDetails']['id'] ==
            currentFirebaseUser!.uid) {
          UserMainScreen.allActiveOrders = activeOrders;
          UserMainScreen.idOfActiveOrderRider = category;
          UserMainScreen.activeOrderDetails = activeOrders[category];
          DatabaseReference? ref = FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(activeOrders[category]['orderDetails']['riderId']);
          DatabaseEvent driverDetailEvent = await ref.once();
          UserMainScreen.OrderDetailsOfCurrenRider =
              driverDetailEvent.snapshot.value;

          print("=============Active Order Get Successfully==================");
          drawPoliline();
            if (activeOrders[category]['orderDetails']['userNotification'] ==
                true) {
              activeOrders[category]['orderDetails']['userNotification'] = false;
              var notificationTitle = activeOrders[category]['orderDetails']['notificationTitle'] ;
              var notificationDesc = activeOrders[category]['orderDetails']['notificationDescription'] ;
          orderRefrence.child(activeOrders[category]['riderId']).set(activeOrders[category]);
          print("=============Active Details===${activeOrders[category]['riderId']}");

        //   Notifiaction call on edit button
          AwesomeNotifications().createNotification(
              content: NotificationContent(
            id: 10,
            channelKey: "basic_channel",
            title: notificationTitle,
            body: notificationDesc,
            bigPicture: "images/petrol.png",
            largeIcon: "images/petrol.png"
          ));
            }
          if (activeOrders[category]['orderDetails']['completed'] == true)
            timer?.cancel();
        }
      }
    }
    setState(() {});
  }

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

  String _address = '';
  late Directions _info;
  @override
  void initState() {
    super.initState();
    print("CUrrent User Info");
    print(userModelCurrentInfo);
    print(currentFirebaseUser!.uid);
    getAllActiveOrders();
    timer = Timer.periodic(
        Duration(seconds: 15), (Timer t) => getAllActiveOrders());
    checkIfLocationPermissionAllowed();
  }

  updateState() {
    UserMainScreen.activeOrderDetails = null;
    UserMainScreen.OrderDetailsOfCurrentUser = null;
    UserMainScreen.OrderDetailsOfCurrenRider = null;
    UserMainScreen.markers.clear();
    UserMainScreen.polyline.clear();
    setState(() {});
  }

  setSourceLocation(userDetails) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("activeDrivers")
        .child(userDetails['riderId'])
        .child("l");
    DatabaseEvent driverLocation = await ref.once();
    var location = driverLocation.snapshot.value as List;
    UserMainScreen.sourceLocation = LatLng(location[0], location[1]);
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
        _address =
            '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}';
        print("Address======${_address}");
      }
    } catch (e) {}
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  _fetchPolylinePoints() async{
    final directions = await DirectionsRepository().getDirections(origin: UserMainScreen.sourceLocation, destination: UserMainScreen.destinationLocation);
    setState(() {
        print("Get the Directions===========================");
        print(directions?.polylinePoints.toString());
      
      _info = directions as Directions;
      if(_info.polylinePoints.length!=0){
        UserMainScreen.polyline.add(Polyline(
      polylineId: PolylineId("route1"),
      visible: true,
      width: 3,
      color: Colors.blueAccent,
      endCap: Cap.buttCap,
      points:_info.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    ));
        
      }
    });
  }

  drawPoliline() async {
    setSourceLocation(UserMainScreen.OrderDetailsOfCurrenRider);
    final Uint8List sourceIcon =
        await getBytesFromAsset('images/user-marker.png', 100);
    final Uint8List destinationIcon =
        await getBytesFromAsset('images/rider-marker.png', 100);

    UserMainScreen.markers.clear();
    UserMainScreen.polyline.clear();
    var userDetails = UserMainScreen.OrderDetailsOfCurrentUser;
    var riderDetails = UserMainScreen.OrderDetailsOfCurrenRider;
    UserMainScreen.destinationLocation = LatLng(
        userDetails['orderDetails']['latitude'],
        userDetails['orderDetails']['longitude']);
    print("Destination =======${UserMainScreen.destinationLocation}");
    print("Source =======${UserMainScreen.sourceLocation}");
    _fetchPolylinePoints();
    UserMainScreen.markers.add(
      Marker(
        markerId: MarkerId("source"),
        position: UserMainScreen.sourceLocation,
        icon: BitmapDescriptor.fromBytes(sourceIcon),
        onTap: () {
          getAddressFromLatLng(UserMainScreen.sourceLocation.latitude,
              UserMainScreen.sourceLocation.longitude);
          var imageUrl = userDetails?['imageUrl'];
          var name = userDetails['name'];
          var phone = userDetails['phone'];
          bool asset = imageUrl != null ? false : true;

          showDetailOnMakers(
              'User Detail', imageUrl, name, phone, _address, asset);
        },
      ),
    );
    UserMainScreen.markers.add(
      Marker(
          markerId: MarkerId("destination"),
          position: UserMainScreen.destinationLocation,
          icon: BitmapDescriptor.fromBytes(destinationIcon),
          onTap: () {
            getAddressFromLatLng(UserMainScreen.destinationLocation.latitude,
                UserMainScreen.destinationLocation.longitude);
            var imageUrl = riderDetails?['imageUrl'];
            var name = riderDetails['name'];
            var phone = riderDetails['phone'];
            bool asset = imageUrl != null ? false : true;

            showDetailOnMakers(
                'Rider Detail', imageUrl, name, phone, _address, asset);
          }),
    );
    // UserMainScreen.polyline.add(Polyline(
    //   polylineId: PolylineId("route1"),
    //   visible: true,
    //   width: 3,
    //   color: Colors.blueAccent,
    //   endCap: Cap.buttCap,
    //   points: [
    //     UserMainScreen.sourceLocation,
    //     UserMainScreen.destinationLocation
    //   ],
    // ));
    print('HOME PAGE REFERENCE');
    setState(() {});
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearbyDriverIconMarker();
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 263,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.black54),
          child: MyDrawer(
            name: userModelCurrentInfo?.name ?? "-",
            email: userModelCurrentInfo?.email ?? "-",
          ),
        ),
      ),
      /*color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
           children:[
             Container(
              height: 165.0,
              child:DrawerHeader(
                decoration: BoxDecoration(color:Colors.white),
                child: Row(
                 children: [
                   Image.asset('images/user-icon.png',height:64,width:65,),
                    SizedBox(width: 16.0,),
                    Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children:[
                     Text("Profile Name",style: TextStyle(fontSize: 16.0,fontFamily: "Brand-Bold"),),
                      SizedBox(width: 16.0,),
                     // Text("Visit Profile"),
                      ]
                    )
                ],
                ),



    ),
    ),
    DividerWidget(),
    SizedBox(height: 12.0,),
    // drawer body buttons
    ListTile(
    leading: Icon(Icons.history),
    title: Text("Order history",style:TextStyle(fontSize: 16.0),),
    ),
    ListTile(
    leading: Icon(Icons.person),
    title: Text("Profile",style:TextStyle(fontSize: 16.0),),
    ),
    ListTile(
    leading: Icon(Icons.info),
    title: Text("About",style:TextStyle(fontSize: 16.0),),
    ),

        ],
    ),

    ),
    ),*/
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            circles: circlesSet,
            polylines: UserMainScreen.polyline,
            markers: UserMainScreen.markers,
            // polylines: _polyline,
            initialCameraPosition: _kGooglePlex,
            //markers: Set<Marker>.of(_markers),
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              blackThemeGoogleMap();
              setState(() {
                bottomPaddingOfMap = 265.0;
              });
              locatePosition();
            },
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: UserMainScreen.activeOrderDetails != null
                //  ||
                //         UserMainScreen.OrderDetailsOfCurrentUser != null
                ?
                // UserMainScreen.activeOrderDetails != null
                //     ?
                UserOrderProgress(
                    updateState: updateState,
                    drawPoliline: drawPoliline,
                  )
                // : UserOrderPlaced()
                : UserMainScreen.OrderDetailsOfCurrentUser != null
                    ? UserOrderPlaced()
                    : Container(
                        height: 250.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18.0),
                              topRight: Radius.circular(18.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 16.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6.0),
                              Text(
                                "Hi There",
                                style: TextStyle(fontSize: 12.0),
                              ),
                              Text(
                                "We got your current location!",
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: "Brand-Bold"),
                              ),
                              SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(2.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        blurRadius: 6.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7, 0.7),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      locatePosition();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                            "Want to reget your current location!"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              // DividerWidget(),

                              //Elevated button use krna ha
                              SizedBox(
                                height: 10.0,
                              ),
                              DividerWidget(),
                              SizedBox(
                                height: 16.0,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderNow()));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //   Text("Order Now ",style: TextStyle(fontSize: 12.0),),
                                        SizedBox(height: 4.0),
                                        Text(
                                          "Order Now!",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Brand-Bold"),
                                        ),
                                        // SizedBox(height: 20.0),
                                      ],
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                              ),

                              /* Row(
                 children: [
                  Icon(Icons.shopping_cart,color: Colors.grey,),
                  SizedBox(width: 12.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text("Add Work",style: TextStyle(fontSize: 12.0),),
                     SizedBox(height: 4.0),
                     Text("Your Working Address",style: TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold"),),
                     SizedBox(height: 20.0),
],
    ),
        ],
        ),*/
                            ],
                          ),
                        ),
                      ),
          ),
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.menu,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 15)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

          //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      UserMainScreen.markers.clear();
      UserMainScreen.polyline.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver" + eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        UserMainScreen.markers = driversMarkerSet;
      });
    });
  }

  createActiveNearbyDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/uber_Moto.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    UserMainScreen.OrderDetailsOfCurrenRider =null;
    UserMainScreen.OrderDetailsOfCurrentUser =null;
    UserMainScreen.sourceLocation=LatLng(0.0, 0.0);
    UserMainScreen.destinationLocation=LatLng(0.0, 0.0);
    UserMainScreen.allActiveOrders?.clear();
    UserMainScreen.idOfActiveOrderRider='';
    UserMainScreen.markers.clear();
    UserMainScreen.polyline.clear();
    UserMainScreen.activeOrderDetails=null;
    super.dispose();
  }
}
