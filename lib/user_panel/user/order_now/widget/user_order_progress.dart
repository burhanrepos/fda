import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:fda/user_panel/user/order_now/widget/rating.dart';
import 'package:fda/user_panel/user_mainscreen/usermain_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../global/global.dart';
import '../../../../widgets/constants.dart';

class UserOrderProgress extends StatefulWidget {
  final Function() updateState;
  final Function() drawPoliline;

  UserOrderProgress({required this.updateState, required this.drawPoliline});
  @override
  _UserOrderProgressState createState() => _UserOrderProgressState();
}

class _UserOrderProgressState extends State<UserOrderProgress> {

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        color: Colors.white,
        height: 300,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Text(
              "Order Status",
              style: TextStyle(
                  color: Constants.applicationThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 23),
            ),
            Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        widget.drawPoliline();
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: true,
                    beforeLineStyle: LineStyle(
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['placed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: UserMainScreen.activeOrderDetails['orderDetails']
                                  ['placed'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData:
                            UserMainScreen.activeOrderDetails['orderDetails']
                                        ['placed'] ==
                                    true
                                ? Icons.check
                                : Icons.info_outline,
                      ),
                    ),
                    afterLineStyle: LineStyle(
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['placed'] ==
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
                    beforeLineStyle: LineStyle(
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['accept'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: UserMainScreen.activeOrderDetails['orderDetails']
                                  ['accept'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData:
                            UserMainScreen.activeOrderDetails['orderDetails']
                                        ['accept'] ==
                                    true
                                ? Icons.check
                                : Icons.info_outline,
                      ),
                    ),
                    afterLineStyle: LineStyle(
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['accept'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter:
                            UserMainScreen.activeOrderDetails['orderDetails']
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
                    beforeLineStyle: LineStyle(
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['processed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: UserMainScreen.activeOrderDetails['orderDetails']
                                  ['processed'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData:
                            UserMainScreen.activeOrderDetails['orderDetails']
                                        ['processed'] ==
                                    true
                                ? Icons.check
                                : Icons.local_shipping,
                      ),
                    ),
                    afterLineStyle: LineStyle(
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['processed'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter:
                            UserMainScreen.activeOrderDetails['orderDetails']
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
                        color: UserMainScreen.activeOrderDetails['orderDetails']
                                    ['delivered'] ==
                                true
                            ? Constants.applicationThemeColor
                            : Colors.grey),
                    indicatorStyle: IndicatorStyle(
                      color: UserMainScreen.activeOrderDetails['orderDetails']
                                  ['delivered'] ==
                              true
                          ? Constants.applicationThemeColor
                          : Colors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData:
                            UserMainScreen.activeOrderDetails['orderDetails']
                                        ['delivered'] ==
                                    true
                                ? Icons.check
                                : Icons.delivery_dining,
                      ),
                    ),
                    //   afterLineStyle: LineStyle(color: UserMainScreen.activeOrderDetails['orderDetails']['delivered']==true?Constants.applicationThemeColor:Colors.grey),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter:
                            UserMainScreen.activeOrderDetails['orderDetails']
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
                                UserMainScreen.activeOrderDetails[
                                            'orderDetails']['completed'] ==
                                        true
                                    ? ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return UserRating(
                                                  updateState:
                                                      widget.updateState);
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Order Received',
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
