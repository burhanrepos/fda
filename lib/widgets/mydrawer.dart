import 'package:fda/splashScreen/usersplash_screen.dart';
import 'package:fda/user_panel/user/user_history/user_history.dart';
import 'package:fda/user_panel/user/user_profile_screen/user_profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fda/global/global.dart';
import 'package:fda/splashScreen/splash_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../user_panel/user/about/about.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({super.key, this.name, this.email});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool editing = false;
  bool loader = false;
  var userProfileDetails;
  List completedOrders = [];
  DatabaseReference? ref = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentFirebaseUser!.uid);

  @override
  initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    try {
    loader = true;
    DatabaseEvent userDetailEvent = await ref!.once();
    userProfileDetails = userDetailEvent.snapshot.value;
    print("User Profile Details");
    print(userProfileDetails);
    setState(() {
      loader = false;
    });
    } catch (e) {
        setState(() {
          loader = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            // height: 165,
            // color: Colors.white,
            decoration: BoxDecoration(color: Colors.transparent),

            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: loader?SpinKitPulse(
                            color: Colors.white,
                            size: 50.0,
                          ):Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userProfileDetails?['imageUrl'] != null
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            userProfileDetails['imageUrl'],
                          ))
                      : CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 40,
            ),
          ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                            userProfileDetails?['name']??"-",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                  Text(
                    userProfileDetails?['email']??"-",
                    maxLines: 1, // Set the maximum number of lines to display
                    overflow:
                        TextOverflow.ellipsis, // Define how to handle overflow
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 12.0,
          ),

          //drawer body
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => UserHistory()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white54,
              ),
              title: Text(
                "History",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => UserProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white54,
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
                              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => UserAboutScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white54,
              ),
              title: Text(
                "About",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const UserSplashScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white54,
              ),
              title: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
