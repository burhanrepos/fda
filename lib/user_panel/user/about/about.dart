import 'package:flutter/material.dart';

class UserAboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/bike.jpg', // Replace with your app logo image asset
                height: 150.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Feul Delivery Application',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Your On-Demand Fuel Delivery Solution',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Text(
                'Feul Delivery Application is your reliable and convenient fuel delivery service. With our app, you can request fuel to be delivered right to your location, just like ordering an Uber. Our team of professional drivers are trained to handle fuel safely and efficiently, ensuring that you receive the highest level of service.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Text(
                'Features of Feul Delivery Application:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              FeatureItem(
                title: 'On-Demand Fuel Delivery',
                description: 'Request fuel through our app and our drivers will deliver it to your location.',
              ),
              FeatureItem(
                title: 'Multiple Fuel Options',
                description: 'Choose from a variety of fuel types, including petrol, diesel, and hi-octane.',
              ),
              FeatureItem(
                title: 'Safe and Secure',
                description: 'Our drivers are trained and equipped with safety gear for professional fuel delivery.',
              ),
              FeatureItem(
                title: 'Reliable and Convenient',
                description: 'Track your fuel delivery in real-time and enjoy prompt and reliable service.',
              ),
              FeatureItem(
                title: 'Payment Options',
                description: 'Seamless and secure payment options cash on delivery.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  FeatureItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40.0,
        ),
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
