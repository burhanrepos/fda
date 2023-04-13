import 'dart:io';

import 'package:fda/user_panel/user_mainscreen/usermain_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../global/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _storage = FirebaseStorage.instance;
  final _database = FirebaseDatabase.instance;

  bool editing = false;
  bool loader = false;
  var userProfileDetails;
  List completedOrders = [];
  DatabaseReference? ref = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentFirebaseUser!.uid);
  DatabaseReference completedOrderReference =
      FirebaseDatabase.instance.ref().child("completedOrder");

  @override
  initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    loader = true;
    var tempCompletedOrders;
    DatabaseEvent userDetailEvent = await ref!.once();
    DatabaseEvent completedOrdersEvent = await completedOrderReference!.once();
    // Get the data once
    userProfileDetails = userDetailEvent.snapshot.value;
    tempCompletedOrders = completedOrdersEvent.snapshot.value;
    completedOrders = [];
    for (var category in tempCompletedOrders.keys) {
      if (tempCompletedOrders[category]['id'] == currentFirebaseUser!.uid) {
        completedOrders.add(tempCompletedOrders[category]);
      }
    }
    print(completedOrders.length);
    if (userProfileDetails != null) {
      _nameController.text = userProfileDetails['name'];
      _phoneController.text = userProfileDetails['phone'];
    }
    print("User Profile Details");
    print(userProfileDetails);
    setState(() {
      loader = false;
    });
  }

  saveUserData() {
    ref!.child('name').set(_nameController.value.text);
    ref!.child('phone').set(_phoneController.value.text);
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          editing
              ? Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            editing = !editing;
                          });
                        },
                        child: Text(
                          'cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                    TextButton(
                        onPressed: () {
                          saveUserData();
                          setState(() {
                            editing = !editing;
                          });
                        },
                        child:
                            Text('save', style: TextStyle(color: Colors.white)))
                  ],
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      editing = !editing;
                    });
                  },
                  child: Text('edit', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: SingleChildScrollView(
        child: loader
            ? Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SpinKitPulse(
                  color: Colors.black,
                  size: 50.0,
                ),
              )
            : Column(
                children: [
                  SizedBox(height: 16),
                 Stack(
                    children: [
                      // Image(
                      //   image: AssetImage('images/add-image.png'),
                      // ),
                      userProfileDetails['imageUrl'] != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                userProfileDetails['imageUrl'],
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 60,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: CircleAvatar(
                                radius: 30.0,
                                //  backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('images/add-image.png')
                                        as ImageProvider,
                              ),
                              onPressed: () async {
                                // Pick an image file from the device
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                  allowMultiple: false,
                                );

                                if (result != null) {
                                  // Get the selected file's path and name
                                  File file = File(result.files.single.path!);
                                  String fileName = basename(file.path);

                                  // Upload the image to Firebase Storage
                                  Reference ref =
                                      _storage.ref().child('images/$fileName');
                                  UploadTask uploadTask = ref.putFile(file);
                                  TaskSnapshot snapshot = await uploadTask;

                                  // Get the image download URL from Firebase Storage
                                  String imageUrl =
                                      await snapshot.ref.getDownloadURL();
                                  print("IMage download url${imageUrl}");

                                  // Store the image URL in Firebase Realtime Database
                                  DatabaseReference userRef = _database
                                      .reference()
                                      .child('users')
                                      .child(currentFirebaseUser!.uid);
                                  userRef.update({
                                    'imageUrl': imageUrl,
                                  });
                                  getUserData();
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${userProfileDetails['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 16),
                  !editing
                      ? ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Name'),
                          subtitle: Text('${userProfileDetails['name']}'),
                        )
                      : ListTile(
                          leading: Icon(Icons.person),
                          title: TextFormField(
                            controller: _nameController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(fontSize: 21),
                                hintText: 'John Doe',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.mode_edit_outline_outlined,
                                  size: 17,
                                )),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    subtitle: Text('${userProfileDetails['email']}'),
                  ),
                  !editing
                      ? ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Phone'),
                          subtitle: Text('${userProfileDetails['phone']}'),
                        )
                      : ListTile(
                          leading: Icon(Icons.phone),
                          title: TextFormField(
                            controller: _phoneController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                label: Text('Phone'),
                                hintText: '555-555-5555',
                                labelStyle: TextStyle(fontSize: 21),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.mode_edit_outline_outlined,
                                  size: 17,
                                )),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Orders Placed'),
                    subtitle: Text('${completedOrders.length}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Member Since'),
                    subtitle: Text(
                        '${DateFormat('dd-MM-yyyy').format(currentFirebaseUser!.metadata.creationTime!)}'),
                  ),
                ],
              ),
      ),
    );
  }
}
