import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nctserviceapp/view/loginpage.dart';
import 'package:nctserviceapp/view/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/localnotificationservice.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(const NCTAPP());
}

class NCTAPP extends StatefulWidget {
  const NCTAPP({Key? key}) : super(key: key);

  @override
  State<NCTAPP> createState() => _NCTAPPState();
}

class _NCTAPPState extends State<NCTAPP> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        home: const Checkpage());
  }
}

class Checkpage extends StatefulWidget {
  const Checkpage({Key? key}) : super(key: key);

  @override
  State<Checkpage> createState() => _CheckpageState();
}

class _CheckpageState extends State<Checkpage> {
  void fetch() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool islogin = prefs.getBool('islogin') ?? false;

      if (islogin) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Mainpage()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4));
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
