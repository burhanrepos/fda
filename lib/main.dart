import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fda/splashScreen/splash_screen.dart';
import 'package:fda/widgets/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Color darkColor = Constants.applicationThemeColor;
MaterialColor primaryColor = MaterialColor(
  darkColor.value,
  <int, Color>{
    50: darkColor.withOpacity(0.1),
    100: darkColor.withOpacity(0.2),
    200: darkColor.withOpacity(0.3),
    300: darkColor.withOpacity(0.4),
    400: darkColor.withOpacity(0.5),
    500: darkColor.withOpacity(0.6),
    600: darkColor.withOpacity(0.7),
    700: darkColor.withOpacity(0.8),
    800: darkColor.withOpacity(0.9),
    900: darkColor.withOpacity(1.0),
  },
);
AwesomeNotifications().initialize(
    null,
    [
        NotificationChannel(channelKey: 'basic_channel', channelName: "Basic Notification", channelDescription: "Notifaicaiton Channel for basic tests")
    ],
    debug: true
);


  runApp(
    MyApp(
      child:MaterialApp(
        title: 'Fuel Deliver APP',
        theme: ThemeData(
            fontFamily: "Poppins",
          primarySwatch: primaryColor,
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
