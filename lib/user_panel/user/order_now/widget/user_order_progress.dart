import 'package:fda/rider_panel/tabPages/home_tab/widgets/popup_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../global/global.dart';

class UserOrderProgress extends StatefulWidget {
  const UserOrderProgress({Key? key}) : super(key: key);
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
        child: ListView(
          children: [
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
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
