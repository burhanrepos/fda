import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:fda/widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../../../global/global.dart';
import '../home_tab.dart';

class OrderProgressBar extends StatefulWidget {
  final Function() updateState;
  const OrderProgressBar({
    Key? key,
    required this.updateState,
  }) : super(key: key);
  @override
  _OrderProgressBarState createState() => _OrderProgressBarState();
}

class _OrderProgressBarState extends State<OrderProgressBar> {
  DatabaseReference orderRefrence =
      FirebaseDatabase.instance.ref().child("activeOrders");
  Timer? timer;
  String _address = '';

  @override
  void initState() {
    super.initState();
    getCurrentOrderStatus();
    timer = Timer.periodic(
        Duration(seconds: 15), (Timer t) => getCurrentOrderStatus());
    setState(() {});
  }

  getCurrentOrderStatus() async {
    print("sdlkafsdjfalksdjfalkdsfjalkdfjalk;dsfjaslkdfjalksdfjalkfdjalk;fj");
    DatabaseEvent driverOrderEvent =
        await orderRefrence.child(currentFirebaseUser!.uid).once();
    if (PopupContainer.currentRiderOrderInProgress != null) {
      PopupContainer.currentRiderOrderInProgress =
          driverOrderEvent.snapshot.value;
    } else {
      timer?.cancel();
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

  drawPoliline(userDetails) async {
    var riderDetails;
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(userDetails['orderDetails']['riderId']);

    DatabaseEvent driverDetailEvent = await ref.once();
    riderDetails = driverDetailEvent.snapshot.value;
    final Uint8List sourceIcon =
        await getBytesFromAsset('images/user-marker.png', 200);
    final Uint8List destinationIcon =
        await getBytesFromAsset('images/rider-marker.png', 200);

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
    print("Destination =======${RiderHomeTabPage.destinationLocation}");
    print("Source =======${RiderHomeTabPage.sourceLocation}");
    RiderHomeTabPage.markers.clear();
    RiderHomeTabPage.polyline.clear();
    RiderHomeTabPage.markers.add(
      Marker(
        markerId: MarkerId("source"),
        position: RiderHomeTabPage.sourceLocation,
        icon: BitmapDescriptor.fromBytes(sourceIcon),
        onTap: () {
          getAddressFromLatLng(RiderHomeTabPage.sourceLocation.latitude,
              RiderHomeTabPage.sourceLocation.longitude);
          var imageUrl = userDetails?['imageUrl'];
          var name = userDetails['name'];
          var phone = userDetails['phone'];
          bool asset = imageUrl != null ? false : true;

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
          getAddressFromLatLng(RiderHomeTabPage.destinationLocation.latitude,
              RiderHomeTabPage.destinationLocation.longitude);
          var imageUrl = riderDetails?['imageUrl'];
          var name = riderDetails['name'];
          var phone = riderDetails['phone'];
          bool asset = imageUrl != null ? false : true;

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
      points: [
        RiderHomeTabPage.sourceLocation,
        RiderHomeTabPage.destinationLocation
      ],
    ));
    print('HOME PAGE REFERENCE');
    widget.updateState();
    // Navigator.of(context).pop();
  }

  orderProcessed(userDetails) {
    userDetails['orderDetails']['processed'] = true;
    userDetails['orderDetails']['userNotification'] == true;
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);

    setState(() {});
  }

  orderDelivered(userDetails) {
    userDetails['orderDetails']['delivered'] = true;
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);
    setState(() {});
  }

  orderCompleted(userDetails) {
    userDetails['orderDetails']['completed'] = true;
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);
    removeOrderFromUser(userDetails);
    setState(() {});
  }

  removeOrderFromUser(userDetails) {
    print("User Details runtime type ==");
    Map<Object?, Object?> userForRemovalOrder = {
      ...userDetails
    }; // The original Map that you want to clone
    userForRemovalOrder.remove('orderDetails');
    DatabaseReference removeOrderReference =
        FirebaseDatabase.instance.ref().child("users").child(userDetails['id']);
    removeOrderReference.set(userForRemovalOrder);
    print("User Details runtime type After==");
  }

  orderRemovedFromActiveOrder(userDetails) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("completedOrder").push();
    ref.set(userDetails['orderDetails']);
    orderRefrence.child(currentFirebaseUser!.uid).remove();
    PopupContainer.currentRiderOrderInProgress = null;
    PopupContainer.driverWithActiveOrder = false;
    RiderHomeTabPage.markers.clear();
    RiderHomeTabPage.polyline.clear();
    widget.updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 300,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.zero,
        child: PopupContainer.currentRiderOrderInProgress != null
            ? ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        drawPoliline(
                            PopupContainer.currentRiderOrderInProgress);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Locate on map",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: true,
                    beforeLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['placed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: PopupContainer.currentRiderOrderInProgress[
                                  'orderDetails']['placed'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['placed'] ==
                                true
                            ? Icons.check
                            : Icons.info_outline,
                      ),
                    ),
                    afterLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['placed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "images/orderPlaced.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order placed',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'We have recieved your order',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    beforeLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['accept'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: PopupContainer.currentRiderOrderInProgress[
                                  'orderDetails']['accept'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['accept'] ==
                                true
                            ? Icons.check
                            : Icons.info_outline,
                      ),
                    ),
                    afterLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['accept'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['accept'] ==
                                true
                            ? ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.color,
                              )
                            : ColorFilter.mode(
                                Colors.white,
                                BlendMode.saturation,
                              ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "images/orderAccepted.png",
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order confirmed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Your order has been confirmed',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                PopupContainer.currentRiderOrderInProgress[
                                                'orderDetails']['accept'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['processed'] ==
                                            false
                                    ? ElevatedButton(
                                        onPressed: () {
                                          orderProcessed(PopupContainer
                                              .currentRiderOrderInProgress);
                                        },
                                        child: Text(
                                          'Move to processing phase',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    beforeLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['processed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: PopupContainer.currentRiderOrderInProgress[
                                  'orderDetails']['processed'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['processed'] ==
                                true
                            ? Icons.check
                            : Icons.local_shipping,
                      ),
                    ),
                    afterLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['processed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['processed'] ==
                                true
                            ? ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.color,
                              )
                            : ColorFilter.mode(
                                Colors.white,
                                BlendMode.saturation,
                              ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "images/orderShipped.png",
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order processed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'We are preparing your order',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                PopupContainer.currentRiderOrderInProgress[
                                                'orderDetails']['processed'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['delivered'] ==
                                            false
                                    ? ElevatedButton(
                                        onPressed: () {
                                          orderDelivered(PopupContainer
                                              .currentRiderOrderInProgress);
                                        },
                                        child: Text(
                                          'Move to delivery phase',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isLast: true,
                    beforeLineStyle: LineStyle(
                        color: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['delivered'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: PopupContainer.currentRiderOrderInProgress[
                                  'orderDetails']['delivered'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['delivered'] ==
                                true
                            ? Icons.check
                            : Icons.delivery_dining,
                      ),
                    ),
                    //   afterLineStyle: LineStyle(color: PopupContainer.currentRiderOrderInProgress['orderDetails']['delivered']==true?Constants.applicationThemeColor:Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: PopupContainer.currentRiderOrderInProgress[
                                    'orderDetails']['delivered'] ==
                                true
                            ? ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.color,
                              )
                            : ColorFilter.mode(
                                Colors.white,
                                BlendMode.saturation,
                              ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "images/orderDeliverd.png",
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ready to pickup',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Your order is ready for pickup',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                (PopupContainer.currentRiderOrderInProgress[
                                                'orderDetails']['completed'] ==
                                            false &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['delivered'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['received'] ==
                                            false)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          setState(() {});
                                          orderCompleted(PopupContainer
                                              .currentRiderOrderInProgress);
                                        },
                                        child: Text(
                                          'Delivered',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                (PopupContainer.currentRiderOrderInProgress[
                                                'orderDetails']['completed'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['delivered'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['received'] ==
                                            true)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          setState(() {});
                                          orderRemovedFromActiveOrder(
                                              PopupContainer
                                                  .currentRiderOrderInProgress);
                                        },
                                        child: Text(
                                          'Completed',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                (PopupContainer.currentRiderOrderInProgress[
                                                'orderDetails']['completed'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['delivered'] ==
                                            true &&
                                        PopupContainer
                                                    .currentRiderOrderInProgress[
                                                'orderDetails']['received'] ==
                                            false)
                                    ? Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color:
                                                Constants.applicationThemeColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Text(
                                          "Wait for Client respose of receving",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(""),
                      SpinKitPulse(
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
