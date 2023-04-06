import 'package:flutter/material.dart';

import '../../../../widgets/mydrawer.dart';

class UserHistoryItem extends StatelessWidget {
  final order;

  UserHistoryItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuel Type: ${order?['Fuel']}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Liters: ${order?['Liter']}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Price: \Rs ${order?['Price']}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                SizedBox(height: 5.0),
          Text(
            'Date of Order: ${order?['orderDate']}',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
              ],
            ),
              );
  }
}
