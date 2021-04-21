import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/books/bookProfile.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/profile/profilebackup.dart';
import 'package:logophile_final/profile/profileui2.dart';
import 'package:logophile_final/services/database.dart';
import 'package:logophile_final/views/chatRoomScreen.dart';
import 'package:logophile_final/views/forum.dart';
import 'package:logophile_final/views/home_page.dart';
import 'package:logophile_final/views/library.dart';
import 'package:logophile_final/views/search_users.dart';
import 'package:logophile_final/views/upload.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _currentIndex = 0;

  String dp = "";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  final List<Widget> _children = [
    HomePage(),
    SearchUsers(),
    Library(),
    Forum(),
    ProfileUI2(),
  ];
  void onTapBar(int index) {
   
    setState(() {
      _currentIndex = index;
    });
  }

  initSearch() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    print(Constants.myName);
    await databaseMethods.getUserByUsername(Constants.myName).then((val) {
      if (this.mounted){
      setState(() {
        searchSnapshot = val;
      });
    }});
    dp = searchSnapshot.docs[0].data()["displaypic"];
  }
  @override
  Widget build(BuildContext context) {
  initSearch();
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTapBar,
          unselectedItemColor: Colors.deepPurple[300],
          selectedItemColor: Colors.white,
          unselectedIconTheme: IconThemeData(color: Colors.deepPurple[300]),
          selectedIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[500],
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                size: 26,
              ),
              title: Text('Feed'),
              // Text("Home",
              //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              title: Text('Search'),
              // Text("Search",
              //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                size: 30,
              ),
              title: Text('Library'),
              // Text("Messaging",
              //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                size: 30,
              ),
              title: Text('Forums'),
              // Text("Messaging",
              //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: dp == ""
                    ? NetworkImage(
                    "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                    : NetworkImage(dp),
                radius: 15.0,
              ),
              // Icon(
              //   AntDesign.profile,
              //   size: 30,
              // ),
              title: Text('Profile'),
              // Text("Profile",
              //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
