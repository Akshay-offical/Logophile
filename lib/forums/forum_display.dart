import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/forums/forum_navbar.dart';
import 'package:logophile_final/forums/forum_upload.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/database.dart';
import 'package:logophile_final/views/profile_page.dart';
import 'package:time_formatter/time_formatter.dart';

String forumname;
void forumNameIs(String name) {
  forumname = name;
}

class ForumDisplay extends StatefulWidget {
  @override
  _ForumDisplayState createState() => _ForumDisplayState();
}

class _ForumDisplayState extends State<ForumDisplay> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  DatabaseMethods databaseMethods2 = new DatabaseMethods();
   DatabaseMethods databaseMethods3 = new DatabaseMethods();

  QuerySnapshot searchSnapshot;
  QuerySnapshot snap;

  DatabaseMethods databaseMethods10 = new DatabaseMethods();
  QuerySnapshot searchSnapshot10;
  QuerySnapshot searchSnapshot3;

  QuerySnapshot doc1;
  String currentEmail;
  String forumName;
  String admin;
  String dp;
  String tp;
  String members;
  String bio;

  bool isLoading = true;
  bool isJoined = false;

  initSearch() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    //print(Constants.myName);
    await databaseMethods.getForumByForumName(forumname).then((val) {
      if (this.mounted) {
        setState(() {
          searchSnapshot = val;
        });
      }
    });
    admin = searchSnapshot.docs[0].data()["admin"];
    forumName = searchSnapshot.docs[0].data()["forumName"];
    dp = searchSnapshot.docs[0].data()["displaypic"];
    tp = searchSnapshot.docs[0].data()["tpic"];
    members = searchSnapshot.docs[0].data()["following"];
    bio = searchSnapshot.docs[0].data()["bio"];

    await databaseMethods1.getUserByUsername(Constants.myName).then((val) {
      if (this.mounted) {
        setState(() {
          snap = val;
        });
      }
    });
    currentEmail = snap.docs[0].data()["email"];

    await databaseMethods10.getForumSpecificFeed(forumName).then((val) {
      if (this.mounted) {
        setState(() {
          searchSnapshot10 = val;
        });
      }
    });

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget feedList() {
    return searchSnapshot10 != null
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchSnapshot10.docs.length,
            //searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print("hello");
              //if(Followers.contains(searchSnapshot.docs[index].data()["uploader"])) {
              return feedTile(
                searchSnapshot10.docs[index].data()["uploader"],
                searchSnapshot10.docs[index].data()["time"],
                searchSnapshot10.docs[index].data()["body"],
                searchSnapshot10.docs[index].data()["title"],
                searchSnapshot10.docs[index].data()["tag"],
                searchSnapshot10.docs[index].id,
                admin
              );
              //}
              return Container();
            },
          )
        : Container();
  }
  @override
  Widget build(BuildContext context) {
    initSearch();

    return Scaffold(
        backgroundColor: Colors.deepPurple[50],
        drawer: currentEmail == admin
            ? ForumNavBar(
                forumName: forumName,
              )
            : null,
        appBar: isLoading
            ? AppBar(
                toolbarHeight: 69,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                        Colors.deepPurple[400],
                        Colors.pink
                      ])),
                ),
              )
            : AppBar(
                toolbarHeight: 69,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                        Colors.deepPurple[400],
                        Colors.pink
                      ])),
                ),
                title: Text(
                  forumName,
                  style: TextStyle(
                    fontFamily: "Signatra",
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  //NetworkImage("https://picsum.photos/250?image=9")
                                  tp == ""
                                      ? AssetImage("assets/images/profile.png")
                                      : NetworkImage(tp),
                              fit: BoxFit.cover)),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: Container(
                          alignment: Alignment(0.0, 2.5),
                          child: CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.pink,
                            child: CircleAvatar(
                              backgroundImage: dp == ""
                                  ? NetworkImage(
                                      "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                                  : NetworkImage(dp),
                              radius: 70.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90,
                    ),
                    Container(
                      width: 370,
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'f/$forumName',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Text(
                                bio,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 9),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForumUpload(forumName)));
                      },
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 150.0,
                          maxHeight: 40.0,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Post to this forum",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Recent Posts',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600),
                    ),
                    feedList(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
  }
}

class feedTile extends StatefulWidget {
  final String userEmail;
  final int time;
  final String body;
  final String title;
  final String tags;
  final String id;
  final String admin;
  feedTile(this.userEmail, this.time, this.body, this.title, this.tags,this.id, this.admin);

  @override
  _feedTileState createState() => _feedTileState();
}

class _feedTileState extends State<feedTile> {
  QuerySnapshot searchSnapshot1;
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot2;
   QuerySnapshot searchSnapshot3;

  DatabaseMethods databaseMethods2 = new DatabaseMethods();
  DatabaseMethods databaseMethods3 = new DatabaseMethods();

  getUserInfo(String username) {
    if (username == null)
      return null;
    else {
      databaseMethods1.getUserByUserEmail(username).then((value) {
        if (this.mounted)
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
        if (this.mounted)
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
  getadminName(String username) {
    if (username == null)
      return null;
    else {
      databaseMethods3.getUserByUserEmail(username).then((value) {
        if (this.mounted)
          setState(() {
            if (value != null) searchSnapshot3 = value;
            //chatRoomsStream = value;
            // isLoading = false;
          });
        print(value);
      });
      if (searchSnapshot2 != null)
        return searchSnapshot3.docs[0].data()["name"];
      else
        return "";
    }
  }
  deleteForum(String id){
    databaseMethods2.deleteforum(id);
  }
  
  showAlertDialogBox(BuildContext context, String id) {
    Widget cancelbutton = FlatButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.of(
          context,
        ).pop();
      },
    );
    Widget deleteButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        deleteForum(id);
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete",
      ),
      content: Text("Tap Delete for deleting the post"),
      actions: [
        cancelbutton,
        deleteButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String dp = getUserInfo(widget.userEmail);
    String name = getUserName(widget.userEmail);
    String id = widget.id;
    String adminName =  getadminName(widget.admin);

    return SingleChildScrollView(
      child: FadeAnimation(
        0.5,
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: GestureDetector(
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
                      onTap: (){
                        print(name);
                        print(adminName);
                      },
                      onDoubleTap: () {
                        nameIs(name);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      onLongPress: name == Constants.myName || Constants.myName == adminName ? () {
                        showAlertDialogBox(context,id);
                      }
                      : (){},
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
      ),
    );
  }
}
