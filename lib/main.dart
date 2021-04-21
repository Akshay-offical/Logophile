import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/helper/authenticate.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/bottombar.dart';
import 'package:logophile_final/views/chatRoomScreen.dart';
import 'package:logophile_final/views/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        if (value == null)
          userIsLoggedIn = false;
        else
          userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? BottomBar() : Authenticate(),
    );
  }
}
