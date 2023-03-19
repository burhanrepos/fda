import 'package:flutter/material.dart';
class EarningTabPage extends StatefulWidget {
  const EarningTabPage({Key? key}) : super(key: key);

  @override
  State<EarningTabPage> createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Row(
          children: [
            Text('Earnings'),
            IconButton(icon: Icon(Icons.access_time_filled),onPressed: (){

            },)
          ],
        ),
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),onPressed: (){},),
        actions: <Widget>[
            IconButton(icon: Icon(Icons.home_filled),onPressed: (){},),
            IconButton(icon: Icon(Icons.info_outline),onPressed: (){},),
            IconButton(icon: Icon(Icons.menu),onPressed: (){},)
        ],

      ),
      floatingActionButton: FloatingActionButton(child: Text("+",style: TextStyle(fontSize: 25),),onPressed: (){},backgroundColor: Colors.orangeAccent,),
      body:Center(child:  Text("Code WIth Burhan",style: TextStyle(fontSize: 40),)),
    );
  }
}
