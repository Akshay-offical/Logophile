import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/Animations/sliding_animations.dart';
import 'package:logophile_final/helper/authenticate.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/database.dart';
import 'package:logophile_final/views/chatRoomScreen.dart';
import 'package:logophile_final/views/feednavpage.dart';
import 'package:logophile_final/views/profile_page.dart';
import 'package:logophile_final/views/upload.dart';
import 'package:time_formatter/time_formatter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot snap;
  int noofpost;
  bool isLoading = true;
  bool noFeed = false;

  List<dynamic> Followers = [];

  Widget feedList() {
    int x = 0;
    //print(searchSnapshot.docs.length);
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            //searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print("hello");
              print(index);
              print(noofpost);
              print(Followers.length);
              print(Followers);
              print(x);
              print(searchSnapshot.docs.length);
              if (Followers.contains(
                  searchSnapshot.docs[index].data()["uploader"])) {
                return feedTile(
                  searchSnapshot.docs[index].data()["uploader"],
                  searchSnapshot.docs[index].data()["time"],
                  searchSnapshot.docs[index].data()["body"],
                  searchSnapshot.docs[index].data()["title"],
                  searchSnapshot.docs[index].data()["tag"],
                );
              } else {
                x++;
                print(x);
                return x == (searchSnapshot.docs.length)
                    ? Container(
                        child: Center(
                            child: Text(
                          'Your feed is empty',
                          style: TextStyle(fontFamily: 'Nunito'),
                        )),
                      )
                    : Container();
              }
            },
          )
        : Container();
  }

  @override
  void initState() {
    getFeedInfo();
    super.initState();
  }

  getFeedInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();

    // databaseMethods1.getUserByUsername(Constants.myName).then((value) {
    //   setState(() {
    //     if(value != null)
    //       snap = value;
    //     //chatRoomsStream = value;
    //     // isLoading = false;
    //   });
    //   //print(value);
    // });

    databaseMethods.getFeed(Constants.myName).then((value) {
      setState(() {
        if (value != null) searchSnapshot = value;

        searchSnapshot.docs.length == 0 ? noFeed = true : noFeed = false;
      });
    });

    databaseMethods.getNoOfPosts(Constants.myName).then((value) {
      setState(() {
        noofpost = value;
      });
    });

    databaseMethods.getFollowers(Constants.myName).then((value) {
      setState(() {
        Followers = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      // drawer: FeedDrawer(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatRoom()));
                },
                child: Icon(Icons.message)),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Upload()));
              },
              child: Icon(Icons.add_box_outlined)),
        ),
        toolbarHeight: 69,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.deepPurple[400], Colors.pink])),
        ),
        title: Center(
          child: Text(
            'Logophile',
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          :
          //DelayedDisplay(
          //delay: Duration(seconds: 1),
          //fadingDuration: Duration(milliseconds: 1),
          noFeed
              ? Container(
                  child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Image(
                          image: AssetImage('assets/images/HomePage.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Your feed is empty',
                      ),
                      Text('Follow other users to get their posts to show up')
                    ],
                  ),
                ))
              : feedList(),
      //),
      // body: Column(
      //   children: [
      //     Center(
      //       child: GestureDetector(
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(
      //                   builder: (context) => ChatRoom()
      //               ));
      //         },
      //         child: Container(
      //           child: Text(
      //             'Go to chat',
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 30.0,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     SizedBox(
      //       height: 50.0,
      //     ),
      //     Center(
      //       child: GestureDetector(
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(
      //                   builder: (context) => SearchUsers()
      //               ));
      //         },
      //         child: Container(
      //           child: Text(
      //             'Search for users',
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 30.0,
      //             ),
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.red,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white54,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.home_ant),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.chat_bubble_mdi),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.upload_ant),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.heart_ant),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.user_ant),
      //       title: Text(''),
      //     ),
      //   ],
      // ),
    );
  }
}

class feedTile extends StatefulWidget {
  final String userEmail;
  final int time;
  final String body;
  final String title;
  final String tags;
  feedTile(this.userEmail, this.time, this.body, this.title, this.tags);

  @override
  _feedTileState createState() => _feedTileState();
}

class _feedTileState extends State<feedTile> {
  QuerySnapshot searchSnapshot1;
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot2;
  DatabaseMethods databaseMethods2 = new DatabaseMethods();

  getUserInfo(String username) {
    if (username == null)
      return null;
    else {
      databaseMethods1.getUserByUserEmail(username).then((value) {
        setState(() {
          if (value != null) searchSnapshot1 = value;
          //chatRoomsStream = value;
          // isLoading = false;
        });
        print(value);
      });
      if (searchSnapshot1 != null)
        return searchSnapshot1.docs[0].data()["displaypic"] == ""
            ? ""
            : searchSnapshot1.docs[0].data()["displaypic"];
      else
        return "";
    }
  }

  getUserName(String username) {
    if (username == null)
      return null;
    else {
      databaseMethods2.getUserByUserEmail(username).then((value) {
        setState(() {
          if (value != null) searchSnapshot2 = value;
          //chatRoomsStream = value;
          // isLoading = false;
        });
        print(value);
      });
      if (searchSnapshot2 != null)
        return searchSnapshot2.docs[0].data()["name"];
      else
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String dp = getUserInfo(widget.userEmail);
    String name = getUserName(widget.userEmail);

    return SingleChildScrollView(
      child: FadeAnimation(
        0.5,
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  GestureDetector(
                    onDoubleTap: (){
                       nameIs(name);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                            Colors.deepPurple[700],
                            Colors.red[300]
                          ])),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.pink,
                          child: CircleAvatar(
                            backgroundImage: dp == ""
                                ? NetworkImage(
                                    "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                                : NetworkImage(dp),
                            radius: 26.0,
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          formatTime(widget.time),
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.body,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontFamily: 'Nunito'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
