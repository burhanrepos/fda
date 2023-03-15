import 'package:fda/rider_panel/tabPages/home_tab/widgets/user_order_request.dart';
import 'package:flutter/material.dart';

import '../home_tab.dart';

class PopupContainer extends StatefulWidget {
    final Function() myState;

  const PopupContainer({required this.myState});

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
    HomeTabPage.markers.clear();
    HomeTabPage.polyline.clear();
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
          child: Visibility(visible: _isOpened, child: UserOrderRequest(
          updateState: widget.myState,
        )),
        ),
      ],
    );
  }
}
