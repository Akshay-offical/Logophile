import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/Animations/animating_search.dart';
import 'package:logophile_final/helper/authenticate.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/database.dart';
import 'package:logophile_final/views/conversation_screen.dart';
import 'package:logophile_final/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods data = new DatabaseMethods();
  bool noChats = false;

  Stream chatRoomsStream;
  String myEmail;
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnapshot1;
  QuerySnapshot searchSnapshot2;
  QuerySnapshot snap1;
  DatabaseMethods databaseMethods1 = new DatabaseMethods();

  Widget chatRoomList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(searchSnapshot.docs.length);
              print(searchSnapshot.docs[index]
                  .data()["chatroomid"]
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(myEmail, ""));
              int i = 0;
              while (i < searchSnapshot.docs.length) {
                print(searchSnapshot.docs.length);
                i++;
                print(i);
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  child: ChatRoomsTile(
                      searchSnapshot.docs[index]
                          .data()["chatroomid"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(myEmail, ""),
                      // searchUser(searchSnapshot.docs[i]
                      //             .data()["chatroomid"]
                      //             .toString()
                      //             .replaceAll("_", "")
                      //             .replaceAll(myEmail, "")),
                      searchSnapshot.docs[index].data()["chatroomid"],
                      initiateSearch(searchSnapshot.docs[i - 1]
                          .data()["chatroomid"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(myEmail, ""))),
                );
              }
              return null;
            },
          )
        : Container();
  }

  String initiateSearch(String userName) {
    if (userName == null)
      return "";
    else {
      databaseMethods1.getUserByUserEmail(userName).then((val) {
        setState(() {
          if (val != null) searchSnapshot1 = val;
          //print(val);
          //isLoading = false;
        });
      });
      if (searchSnapshot1 != null)
        return searchSnapshot1.docs[0].data()["displaypic"] == ""
            ? ""
            : searchSnapshot1.docs[0].data()["displaypic"];
      else
        return "";
    }
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  bool isLoading = true;

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    myEmail = await HelperFunctions.getUserEmailSharedPreference();
    print(myEmail);

    databaseMethods.getChatRooms(myEmail).then((value) {
      setState(() {
        if (value != null) searchSnapshot = value;

        searchSnapshot.docs.length == 0 ? noChats = true : noChats = false;
        isLoading = false;
      });
      print(value);
      print(searchSnapshot.docs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(

        
        toolbarHeight: 69,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.deepPurple[400],
                   Colors.pink])),
        ),
        title: 
         Text(
              'Connect',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
        ),
        
    
      body: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          AnimatedSearchBar(page: SearchScreen(),),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: 150.0,
              color: Colors.deepPurple[50],
            ),
          ),
          isLoading
              ? Expanded(
                  child: Container(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              : noChats
                  ? Expanded(
                      child: Container(
                      child: Center(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(
                                image: AssetImage('assets/images/chatting.png'),
                              ),
                            ),
                            Text(
                              'You have no chats',
                            ),
                            Text(
                                'Search for a user to start chatting with them')
                          ],
                        ),
                      )),
                    ))
                  : Expanded(child: chatRoomList()),
        ],
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final String url;

  ChatRoomsTile(this.userName, this.chatRoomId, this.url);

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  QuerySnapshot searchSnapshot2;
  DatabaseMethods databaseMethods2 = new DatabaseMethods();
  QuerySnapshot snap10;
  DatabaseMethods data10 = new DatabaseMethods();

  String initiateSearch1(String userName) {
    if (userName == null)
      return null;
    else {
      databaseMethods2.getUserByUserEmail(userName).then((val) {
        setState(() {
          if (val != null) searchSnapshot2 = val;
          //print(val);
          //isLoading = false;
        });
      });
      if (searchSnapshot2 != null)
        return searchSnapshot2.docs[0].data()["displaypic"] == ""
            ? ""
            : searchSnapshot2.docs[0].data()["displaypic"];
      else
        return "";
    }
  }

  String searchUser(String userEmail) {
    if (userEmail == null)
      return null;
    else {
      data10.getUserByUserEmail(userEmail).then((val) {
        setState(() {
          if (val != null) snap10 = val;
        });
      });
      if (snap10 != null)
        return snap10.docs[0].data()["name"];
      else
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userName);
    String url1 = initiateSearch1(widget.userName);
    String chatName = searchUser(widget.userName);
    //String url = initiateSearch(userName);
    return SingleChildScrollView(
      child: FadeAnimation(
        1,
        Container(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConversationScreen(
                          widget.chatRoomId,
                          chatName,
                          //widget.url
                          url1)));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: CircleAvatar(
                      backgroundImage: url1 == ""
                          ? NetworkImage(
                              "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                          : NetworkImage(url1),
                      radius: 70.0,
                    ),
                    // Text("${userName.substring(0,1).toUpperCase()}",
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 25.0,
                    //   ),
                    // ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    chatName,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      fontSize: 18.0,
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
