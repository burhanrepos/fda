import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../home_tab.dart';

class UserOrderRequest extends StatelessWidget {
//   const UserOrderRequest({
//     super.key,
//   });
final Function() updateState;
const UserOrderRequest({
    Key? key,
    required this.updateState,
  }) : super(key: key);

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
                   HomeTabPage.destinationLocation = LatLng(userDetails['orderDetails']['latitude'], userDetails['orderDetails']['longitude']);
                   print("Destination =======${HomeTabPage.destinationLocation}");
                   print("Source =======${HomeTabPage.sourceLocation}");
                   HomeTabPage.markers.add(
                    Marker(
                        markerId: MarkerId("source"),
                        position: HomeTabPage.sourceLocation,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                        infoWindow: InfoWindow(
                        title: "Source",
                        ),
                    ),
                    );
                    HomeTabPage.markers.add(
                    Marker(
                        markerId: MarkerId("destination"),
                        position: HomeTabPage.destinationLocation,
                        infoWindow: InfoWindow(
                        title: "Destination",
                        ),
                    ),
                    );
                    HomeTabPage.polyline.add(Polyline(
                    polylineId: PolylineId("route1"),
                    visible: true,
                    width: 10,
                    color: Colors.blueAccent,
                    endCap: Cap.buttCap,
                    points: [HomeTabPage.sourceLocation, HomeTabPage.destinationLocation],
                    ));
                  print('HOME PAGE REFERENCE');
                  Navigator.of(context).pop();
                  updateState();
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
