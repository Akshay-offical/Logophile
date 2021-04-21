
// final GoogleSignIn gSignIn = GoogleSignIn();

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logophile_final/helper/authenticate.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/profile/editprofile.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/database.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  bool isLoading = true;
  String userName;
  String tp;
  initSearch() async {
    await databaseMethods.getUserByUsername(Constants.myName).then((val) {
      if(this.mounted)
      {setState(() {
        searchSnapshot = val;
      });
    }});
    userName = searchSnapshot.docs[0].data()["name"];
    tp = searchSnapshot.docs[0].data()["tpic"];
    // userEmail = searchSnapshot.docs[0].data()["email"];
    // batch = searchSnapshot.docs[0].data()["batch"];
    // Fname = searchSnapshot.docs[0].data()["fname"];
    // Lname = searchSnapshot.docs[0].data()["lname"];
    // club = searchSnapshot.docs[0].data()["club"];
    // dept = searchSnapshot.docs[0].data()["dept"];

    if(this.mounted){
    setState(() {
      isLoading = false;
    });
  }}

  // Future<void> signoutFromGoogle() async {
  //
  //   final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
  //   print(gSignIn.currentUser);
  //
  //   //await authMethods.signOut().then((value) {
  //      gSignIn.signOut();
  //     print("sign out successful");
  //     HelperFunctions.saveUserLoggedInSharedPreference(false);
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(
  //             builder: (context) => Authenticate()
  //         )
  //     );
  // }

  @override
  Widget build(BuildContext context) {
    initSearch();
    return Drawer(
      child: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    userName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                        color: Colors.purple
                      ),
                ),
              
                ListTile(
                    leading: Icon(Feather.edit),
                    title: Text('Edit Profile',
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                    onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => edit()))
                        }),

                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () {
                    // if(Constants.GoogleLogIn == "yes") {
                    //   //setState(() {
                    //     Constants.GoogleLogIn = "no";
                    //   //});
                    //   await signoutFromGoogle();
                    //   print("logged out successfully");
                    //   //gSignIn.signOut();
                    //   //Future.delayed(const Duration(seconds: 4), () {
                    //   //   HelperFunctions.saveUserLoggedInSharedPreference(false);
                    //   //   Navigator.pushReplacement(context,
                    //   //       MaterialPageRoute(
                    //   //           builder: (context) => Authenticate()
                    //   //       )
                    //   //   );
                    //   // });
                    // }
                    //   else {
                    authMethods.signOut();
                    HelperFunctions.saveUserLoggedInSharedPreference(false);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
                  },
                ),
              ],
            ),
    );
  }
}
