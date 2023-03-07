import 'dart:async';
import 'package:fda/global/global.dart';
import 'package:fda/mainScreens/orderNow.dart';
import 'package:fda/widgets/divider.dart';
import 'package:fda/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:fda/user/login.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../assistants/assistant_methods.dart';
import '../assistants/geofire_assistant.dart';
import 'package:fda/models/active_nearby_available_drivers.dart';
//import '../mainScreens/searchScreen.dart';
//import '../models/active_nearby_available_drivers.dart';
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

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
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController?newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
 
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

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail = "your Email";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void locatePosition() async{
    Position cPosition=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition=cPosition;
    LatLng latLngPosition= LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition=CameraPosition(target: latLngPosition,zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();

  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );


  blackThemeGoogleMap()
  {
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

  @override
  void initState()
  {
    super.initState();

    checkIfLocationPermissionAllowed();
  }
  

  @override
  Widget build(BuildContext context) {
    createActiveNearbyDriverIconMarker();
    return Scaffold(
    key: scaffoldKey,

    drawer: Container(
      width: 263,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black54
        ),
        child: MyDrawer(
          name: userModelCurrentInfo!.name,
          email: userModelCurrentInfo!.email,
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
          markers: markersSet,
          circles: circlesSet,
       // polylines: _polyline,
        initialCameraPosition: _kGooglePlex,
        //markers: Set<Marker>.of(_markers),
          compassEnabled: true,
         onMapCreated: (GoogleMapController controller)
        {
         _controllerGoogleMap.complete(controller);
          newGoogleMapController= controller;
         blackThemeGoogleMap();
          setState(() {
            bottomPaddingOfMap=265.0;
          });
          locatePosition();
    },
    ),
        Positioned(
        right: 0.0,
        left: 0.0,
        bottom: 0.0,
        child: Container(
          height: 250.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
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
            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.0),
                Text("Hi There",style: TextStyle(fontSize: 12.0),),
                Text("We got your current location!",style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap:() {
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
                    child:ElevatedButton(
                      onPressed: () {
                        locatePosition();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey,),
                          SizedBox(width: 4,),
                          Text("Want to reget your current location!"),
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
                 SizedBox(height: 10.0,),
                 DividerWidget(),
                  SizedBox(height: 16.0,),
                 ElevatedButton(onPressed: (){
                   Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderNow()));
                 },

                     child: Row(
                       children: [
                         Icon(Icons.shopping_cart,color: Colors.grey,),
                         SizedBox(width: 12.0,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                          //   Text("Order Now ",style: TextStyle(fontSize: 12.0),),
                             SizedBox(height: 4.0),
                             Text("Order Now!",style: TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold"),),
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
              onTap: ()
              {
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
  initializeGeoFireListener()
  {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(userCurrentPosition!.latitude, userCurrentPosition!.longitude, 15)!.listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack)
            {
        //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);
            if(activeNearbyDriverKeysLoaded == true)
            {
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
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(activeNearbyAvailableDriver);
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

  displayActiveDriversOnUsersMap()
  {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();


      for(ActiveNearbyAvailableDrivers eachDriver in GeoFireAssistant.activeNearbyAvailableDriversList)
      {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver"+eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }
  createActiveNearbyDriverIconMarker(){
    if(activeNearbyIcon==null ){
      ImageConfiguration imageConfiguration =  createLocalImageConfiguration(context,size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/uber_Moto.png").then((value){
        activeNearbyIcon=value;

      });

    }

  }

}
  