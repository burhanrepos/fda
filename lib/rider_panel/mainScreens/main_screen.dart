import 'package:fda/rider_panel/tabPages/earning_tab/earning_tab.dart';
import 'package:fda/rider_panel/tabPages/home_tab/home_tab.dart';
import 'package:fda/rider_panel/tabPages/profile_tab.dart';
import 'package:fda/rider_panel/tabPages/ratings_tab.dart';
import 'package:flutter/material.dart';
class MainScreen extends StatefulWidget {


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>with TickerProviderStateMixin {
  TabController? tabController;
  late AnimationController _animationController;
  int selectedIndex=0;
  onItemClicked(int index){
    setState(() {
      selectedIndex= index;
      tabController!.index =selectedIndex;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController= TabController(length: 4, vsync: this);
     _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }
int _currentIndex = 0;

  final List<Widget> _tabs = [
          RiderHomeTabPage(),
          RiderEarningTabPage(),
          RiderRatingsTabPage(),
          RiderProfileTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
           _animationController.forward(from: 0.0);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Ratings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(size: 40),
        unselectedIconTheme: IconThemeData(size: 20),
        selectedFontSize: 14,
        unselectedFontSize: 12,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
