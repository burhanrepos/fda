import 'dart:io';

import 'package:fda/rider_panel/tabPages/profile_tab/widget/bike_info_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fda/global/global.dart';
import 'package:fda/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';

class RiderProfileTabPage extends StatefulWidget {
  const RiderProfileTabPage({Key? key}) : super(key: key);

  @override
  State<RiderProfileTabPage> createState() => _RiderProfileTabPageState();
}

class _RiderProfileTabPageState extends State<RiderProfileTabPage> {
  var driverDetails;
  bool loader = false;
  String _rating = '0.0';
  final _storage = FirebaseStorage.instance;
  final _database = FirebaseDatabase.instance;

  @override
  initState() {
    getProfileData();
  }

  getProfileData() async {
    setState(() {});
    loader = true;
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);
    DatabaseEvent driverDetailEvent = await ref.once();
    DatabaseEvent overallRating = await ref.child("totalRating").once();
    var overAllRatingValue = overallRating.snapshot.value;
    if (overAllRatingValue != null) {
      _rating = double.parse(overAllRatingValue.toString()).toStringAsFixed(1);
    }
    // Get the data once
    driverDetails = driverDetailEvent.snapshot.value;
    print("Driver Details");
    print(driverDetails);
    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
        // automaticallyImplyLeading: false,
        leading: SizedBox(),
        actions: [
          driverDetails?['email']!=null?TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BikeInfoDialog(
                        driverDetails: driverDetails,
                        updateState: () {
                          getProfileData();
                        });
                  },
                );
              },
              child: Text(
                'edit',
                style: TextStyle(color: Colors.white),
              )):SizedBox()
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: loader
          ? SpinKitPulse(
              color: Colors.black,
              size: 50.0,
            )
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Driver Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Stack(
                                  children: [
                                    // Image(
                                    //   image: AssetImage('images/add-image.png'),
                                    // ),
                                    driverDetails['imageUrl'] != null
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                              driverDetails['imageUrl'],
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 50,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                    driverDetails?['email']!=null?Positioned(
                                      bottom: -5,
                                      right: -5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            color: Colors.black,
                                            icon: CircleAvatar(
                                              radius: 30.0,
                                              //  backgroundColor: Colors.transparent,
                                              backgroundImage: AssetImage(
                                                      'images/add-image.png')
                                                  as ImageProvider,
                                            ),
                                            onPressed: () async {
                                              // Pick an image file from the device
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.image,
                                                allowMultiple: false,
                                              );

                                              if (result != null) {
                                                // Get the selected file's path and name
                                                File file = File(
                                                    result.files.single.path!);
                                                String fileName =
                                                    basename(file.path);

                                                // Upload the image to Firebase Storage
                                                Reference ref = _storage
                                                    .ref()
                                                    .child('images/$fileName');
                                                UploadTask uploadTask =
                                                    ref.putFile(file);
                                                TaskSnapshot snapshot =
                                                    await uploadTask;

                                                // Get the image download URL from Firebase Storage
                                                String imageUrl = await snapshot
                                                    .ref
                                                    .getDownloadURL();
                                                print(
                                                    "IMage download url${imageUrl}");

                                                // Store the image URL in Firebase Realtime Database
                                                DatabaseReference driverRef =
                                                    _database
                                                        .reference()
                                                        .child('drivers')
                                                        .child(
                                                            currentFirebaseUser!
                                                                .uid);
                                                driverRef.update({
                                                  'imageUrl': imageUrl,
                                                });
                                                getProfileData();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ):SizedBox(),
                                  ],
                                ),
                              ),
                             
                            //   SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.4,
                                    child: Text(
                                      '${driverDetails?['name'] ?? '-'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis, 
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Rating: ${_rating}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${driverDetails?['email']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${driverDetails?['phone']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Vehicle Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Make',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${driverDetails?['bike_details']?['bike_make'] ?? '-'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Model',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${driverDetails?['bike_details']?['bike_model'] ?? '-'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'License Plate',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${driverDetails?['bike_details']?['bike_number'] ?? '-'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: Text('Sign Out'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(250, 42, 40, 40),
                          ),
                          onPressed: () {
                            fAuth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const MySplashScreen()));
                          },
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
