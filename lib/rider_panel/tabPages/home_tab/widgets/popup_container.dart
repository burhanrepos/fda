import 'package:fda/rider_panel/tabPages/home_tab/widgets/order_progress_bar.dart';
import 'package:fda/rider_panel/tabPages/home_tab/widgets/user_order_request.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../global/global.dart';
import '../home_tab.dart';

class PopupContainer extends StatefulWidget {
  final Function() myState;
  static bool driverWithActiveOrder = false;
  static var currentRiderOrderInProgress;

  const PopupContainer({required this.myState});

  @override
  _PopupContainerState createState() => _PopupContainerState();
}

class _PopupContainerState extends State<PopupContainer>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _isOpened = false;
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("activeOrders")
      .child(currentFirebaseUser!.uid);
  var snapshotDriversOrder;
  bool loadingOrder = false;

  @override
  void initState() {
    super.initState();
    checkDriverWithOrder();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
        parent: _animationController!, curve: Curves.fastLinearToSlowEaseIn);
  }

  Future<void> getCurrentOrder() async {
    DatabaseReference orderRefrence =
        FirebaseDatabase.instance.ref().child("activeOrders");
    DatabaseEvent driverOrderEvent =
        await orderRefrence.child(currentFirebaseUser!.uid).once();
    PopupContainer.currentRiderOrderInProgress =
        driverOrderEvent.snapshot.value;
    print("Order In Progress=============-----------------");
    print(PopupContainer.currentRiderOrderInProgress);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    HomeTabPage.allUser.clear();
    HomeTabPage.markers.clear();
    HomeTabPage.polyline.clear();
    PopupContainer.driverWithActiveOrder = false;
    super.dispose();
  }

  checkDriverWithOrder() async {
    snapshotDriversOrder = await ref.get();
    if (snapshotDriversOrder.exists) {
      PopupContainer.driverWithActiveOrder = true;
      loadingOrder = false;
      print("Order exists ========================");
      setState(() {});
      getCurrentOrder();
    } else {
      loadingOrder = false;
      PopupContainer.driverWithActiveOrder = false;
    }
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
            // width: 100,
            constraints: BoxConstraints(
                maxWidth:
                    PopupContainer.driverWithActiveOrder == true ? 150 : 120),
            child: loadingOrder
                ? SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupContainer.driverWithActiveOrder == true
                          ? Text("Order in progress")
                          : Row(
                              children: [
                                Text("Orders "),
                                Text(
                                  '(${HomeTabPage.allUser.length})',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )
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
          child: Visibility(
              visible: _isOpened,
              child: PopupContainer.driverWithActiveOrder == true
                  ? OrderProgressBar(
                      updateState: widget.myState,
                    )
                  : UserOrderRequest(
                      updateState: widget.myState,
                    )),
        ),
      ],
    );
  }
}
