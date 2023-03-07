import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:flutter_share/flutter_share.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
//import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/*class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController PickupTextEditingController=TextEditingController();



  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of(AppData).PickupLocation.placeName ??"";
     PickupTextEditingController.text=placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow:[
                BoxShadow
                  (
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),

              ),]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0,top:25.0,right: 20.0,bottom: 18.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      Icon(Icons.arrow_back),
                      Center(
                        child: Text("Set drop off",style:TextStyle(fontSize: 18.0,fontFamily: "Brand-Bold")),

                      )
                    ],
                  ),
                  SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Image.asset('images/fuelSearch.png',height:16,width: 16,),
                      SizedBox(width: 18.0,),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: PickupTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Pickup Location.",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 6.0,),

                                ),
                              ),
                            ) ,
                          ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Image.asset('images/bike.jpg',height:16,width: 16,),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Where to gooooooooooo.",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 6.0,),

                              ),
                            ),
                          ) ,
                        ),
                      ),
                    ],
                  ),

                ],

              ),
            )
          ),
        ],
      ),
    );
  }
}

 */
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller= TextEditingController();
  var uuid=Uuid();
  String _sessionToken='122344';
  List<dynamic>_placesList=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();

    });
  }
void onChange(){
    if(_sessionToken==Null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
}
void getSuggestion(String input)async{
    String kPLACES_API_KEY="AIzaSyCmnV9YatIfHq_mihV0nJe6tP0Hf2CJpFc";
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response= await http.get(Uri.parse(request));
    var data=response.body.toString();
    print('data');
    print(data);
    if (response.statusCode==200){
      setState(() {
        _placesList=jsonDecode(response.body.toString())['prediction'];
      });

    }
    else{
      throw Exception('Failed to load');

    }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: Image.asset('images/location-arrow.png',height: 16,width: 16,color: Colors.black,),
          ),
        ),
        title: Text('Set Delivery Location'),
      ),
      body:Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
            children:[
              TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search your location',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (context,index){
                  return ListTile(
                   // onTap: ()async{
                    //  List<Location>location=await locationFromAddress(_placesList[index]['description']);
                    //  print(location.last.longitude);
                    //  print(location.last.latitude);
                    // },
                    title: Text(_placesList[index]['description']),
                  );
                },
              ),
            ),
        ],
            ),
          ),
          );

  }
}

