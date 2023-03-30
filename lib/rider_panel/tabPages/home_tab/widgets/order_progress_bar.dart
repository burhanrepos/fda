import 'dart:async';

import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
    
     @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 15), (Timer t) => getCurrentOrderStatus());
        setState(() {
          
        });
  }
  getCurrentOrderStatus()async{
    print("sdlkafsdjfalksdjfalkdsfjalkdfjalk;dsfjaslkdfjalksdfjalkfdjalk;fj");
    DatabaseEvent driverOrderEvent =
        await orderRefrence.child(currentFirebaseUser!.uid).once();
    if(PopupContainer.currentRiderOrderInProgress!=null){
    PopupContainer.currentRiderOrderInProgress =
        driverOrderEvent.snapshot.value;
    }else{
        timer?.cancel();
    }
  }

    drawPoliline(userDetails) {
    HomeTabPage.destinationLocation = LatLng(
        userDetails['orderDetails']['latitude'],
        userDetails['orderDetails']['longitude']);
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
    widget.updateState();
    // Navigator.of(context).pop();
  }

    orderProcessed(userDetails) {
    userDetails['orderDetails']['processed'] = true;
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);
    setState(() {
      
    });
  }

  orderDelivered(userDetails) {
    userDetails['orderDetails']['delivered'] = true;
    orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);
    setState(() {
      
    });
  }
    orderCompleted(userDetails) {
        userDetails['orderDetails']['completed'] = true;
        orderRefrence.child(currentFirebaseUser!.uid).set(userDetails);
        removeOrderFromUser(userDetails);
        setState(() {
        
        });
    }
    removeOrderFromUser(userDetails){
        print("User Details runtime type ==");
    Map<Object?, Object?> userForRemovalOrder = {...userDetails}; // The original Map that you want to clone
    userForRemovalOrder.remove('orderDetails');
    DatabaseReference removeOrderReference =
        FirebaseDatabase.instance.ref().child("users")
        .child(userDetails['id']);
          removeOrderReference.set(userForRemovalOrder);
    print("User Details runtime type After==");
  }
  orderRemovedFromActiveOrder(userDetails) async{
    
DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("completedOrder")
      .child(currentFirebaseUser!.uid).push();
      ref.set(userDetails['orderDetails']);
      orderRefrence.child(currentFirebaseUser!.uid).remove();
      PopupContainer.currentRiderOrderInProgress = null;
      PopupContainer.driverWithActiveOrder = false;
      HomeTabPage.markers.clear();
      HomeTabPage.polyline.clear();
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
        child: PopupContainer.currentRiderOrderInProgress != null ? ListView(
          padding: EdgeInsets.zero,
          children: [
                  Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          drawPoliline(PopupContainer.currentRiderOrderInProgress);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Locate on map",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.redAccent),),
            Icon(Icons.location_on,color: Colors.redAccent,),
          ],
        ),
      ),
    ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              beforeLineStyle: LineStyle(
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['placed'] ==
                              true
                          ? Colors.green
                          : Colors.grey),
              indicatorStyle: IndicatorStyle(
                color:
                    PopupContainer.currentRiderOrderInProgress['orderDetails']
                                ['placed'] ==
                            true
                        ? Colors.green
                        : Colors.grey,
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['placed'] ==
                              true
                          ? Icons.check
                          : Icons.info_outline,
                ),
              ),
              afterLineStyle: LineStyle(
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['placed'] ==
                              true
                          ? Colors.green
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
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['accept'] ==
                              true
                          ? Colors.green
                          : Colors.grey),
              indicatorStyle: IndicatorStyle(
                color:
                    PopupContainer.currentRiderOrderInProgress['orderDetails']
                                ['accept'] ==
                            true
                        ? Colors.green
                        : Colors.grey,
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['accept'] ==
                              true
                          ? Icons.check
                          : Icons.info_outline,
                ),
              ),
              afterLineStyle: LineStyle(
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['accept'] ==
                              true
                          ? Colors.green
                          : Colors.grey),
              endChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ColorFiltered(
                  colorFilter:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['accept'] ==
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
                        PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['accept'] ==
                              true && PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['processed'] == false
                          ?ElevatedButton(onPressed: (){
                              orderProcessed(PopupContainer.currentRiderOrderInProgress);
                          }, child: Text(
                          'Move to processing phase',
                          style: TextStyle(
                            fontSize: 16,
                            
                          ),
                        ),):Container()
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
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['processed'] ==
                              true
                          ? Colors.green
                          : Colors.grey),
              indicatorStyle: IndicatorStyle(
                color:
                    PopupContainer.currentRiderOrderInProgress['orderDetails']
                                ['processed'] ==
                            true
                        ? Colors.green
                        : Colors.grey,
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['processed'] ==
                              true
                          ? Icons.check
                          : Icons.local_shipping,
                ),
              ),
              afterLineStyle: LineStyle(
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['processed'] ==
                              true
                          ? Colors.green
                          : Colors.grey),
              endChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ColorFiltered(
                  colorFilter:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['processed'] ==
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
                        PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['processed'] ==
                              true && PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] == false
                          ?ElevatedButton(onPressed: (){
                              orderDelivered(PopupContainer.currentRiderOrderInProgress);
                          }, child: Text(
                          'Move to delivery phase',
                          style: TextStyle(
                            fontSize: 16,
                            
                          ),
                        ),):Container()
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
                  color:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] ==
                              true
                          ? Colors.green
                          : Colors.grey),
              indicatorStyle: IndicatorStyle(
                color:
                    PopupContainer.currentRiderOrderInProgress['orderDetails']
                                ['delivered'] ==
                            true
                        ? Colors.green
                        : Colors.grey,
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] ==
                              true
                          ? Icons.check
                          : Icons.delivery_dining,
                ),
              ),
              //   afterLineStyle: LineStyle(color: PopupContainer.currentRiderOrderInProgress['orderDetails']['delivered']==true?Colors.green:Colors.grey),
              endChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ColorFiltered(
                  colorFilter:
                      PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] ==
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
                        PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] == true || PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['received'] == true
                          ?ElevatedButton(onPressed: (){
                            print("Order Status ===============${PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['received']}");
                                  setState(() {
                                    
                                  });
                                  
                              PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] == true && PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['received'] == false?orderCompleted(PopupContainer.currentRiderOrderInProgress):orderRemovedFromActiveOrder(PopupContainer.currentRiderOrderInProgress);
                          }, child: Text(
                          PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['delivered'] == true && PopupContainer.currentRiderOrderInProgress['orderDetails']
                                  ['completed'] == false?'Delivered':'Completed',
                          style: TextStyle(
                            fontSize: 16,
                            
                          ),
                        ),):Container()
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ):Center(
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
