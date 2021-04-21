

// final GoogleSignIn gSignIn = GoogleSignIn();



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/database.dart';

class FeedDrawer extends StatefulWidget {
  @override
  _FeedDrawerState createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
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

    setState(() {
      isLoading = false;
    });
  }

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
                        fontSize: 25,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: tp == ""
                            ? NetworkImage(
                                "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg")
                            : NetworkImage(tp),
                      )),
                ),
                
                
               
                SizedBox(
                  height: 20,
                ),
               
                SizedBox(
                  height: 50,
                ),
              ],
            ),
    );
  }
}
