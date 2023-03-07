import 'package:fda/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
    MyApp(
      child:MaterialApp(
        title: 'Fuel Deliver APP',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),

  );
}

class MyApp extends StatefulWidget {
  final Widget? child;
  const MyApp({super.key, this.child});
  static void restartAPP(BuildContext context)
  {
    context.findAncestorStateOfType<_MyAppState >()!.restartAPP();

  }

  @override
  State<MyApp> createState() => _MyAppState();


}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartAPP(){
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
        child: widget.child!,
    );
  }
}
