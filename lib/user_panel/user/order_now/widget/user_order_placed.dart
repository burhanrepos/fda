import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:fda/user_panel/user/order_now/widget/rating.dart';
import 'package:fda/user_panel/user_mainscreen/usermain_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../global/global.dart';
import '../../../../widgets/constants.dart';

class UserOrderPlaced extends StatefulWidget {
  UserOrderPlaced();
  @override
  _UserOrderPlacedState createState() => _UserOrderPlacedState();
}

class _UserOrderPlacedState extends State<UserOrderPlaced> {
  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        height: 250.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 16.0,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Order Status",
              style: TextStyle(
                  color: Constants.applicationThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 23),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: true,
                    beforeLineStyle:
                        LineStyle(color: Constants.applicationThemeColor),
                    indicatorStyle: IndicatorStyle(
                      color: Constants.applicationThemeColor,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                      ),
                    ),
                    afterLineStyle:
                        LineStyle(color: Constants.applicationThemeColor),
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
                                'We have recieved your order.',
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
                    beforeLineStyle: LineStyle(color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.info_outline,
                      ),
                    ),
                    afterLineStyle: LineStyle(color: Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
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
                                  'Your order has been confirmed.',
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
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    beforeLineStyle: LineStyle(color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.local_shipping,
                      ),
                    ),
                    afterLineStyle: LineStyle(color: Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
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
                    beforeLineStyle: LineStyle(color: Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.delivery_dining,
                      ),
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Do you recieved your order
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
