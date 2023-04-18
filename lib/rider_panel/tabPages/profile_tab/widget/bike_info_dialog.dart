import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../global/global.dart';

class BikeInfoDialog extends StatefulWidget {
  final driverDetails;

  final Function() updateState;

  const BikeInfoDialog(
      {required this.driverDetails, required this.updateState});

  @override
  _BikeInfoDialogState createState() => _BikeInfoDialogState();
}

class _BikeInfoDialogState extends State<BikeInfoDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.driverDetails['name'] ?? '';
    phoneController.text = widget.driverDetails['phone'] ?? '';
    makeController.text =
        widget.driverDetails['bike_details']?['bike_make'] ?? '-';
    modelController.text =
        widget.driverDetails['bike_details']?['bike_model'] ?? '-';
    licensePlateController.text =
        widget.driverDetails['bike_details']?['bike_number'] ?? '-';
    setState(() {});
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update Rider Information',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Phone #',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: phoneController,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(),
            Row(
              children: [
                Text(
                  'Update Vehicle Information',
                  textAlign: TextAlign.start,

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Make',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: makeController,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Model',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: modelController,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'No Plate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: licensePlateController,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('cancel'),
        ),
        TextButton(
          onPressed: () {
            
            DatabaseReference? ref = FirebaseDatabase.instance
                .ref()
                .child("drivers")
                .child(currentFirebaseUser!.uid);
                 ref
                .child('name')
                .set(nameController.value.text);
                 ref
                .child('phone')
                .set(phoneController.value.text);
            ref
                .child('bike_details')
                .child('bike_make')
                .set(makeController.value.text);
            ref
                .child('bike_details')
                .child('bike_model')
                .set(modelController.value.text);
            ref
                .child('bike_details')
                .child('bike_number')
                .set(licensePlateController.value.text);
            Navigator.pop(context);
            widget.updateState();
            // getUserData();
          },
          child: Text('update'),
        ),
      ],
    );
  }
}
