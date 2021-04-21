import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/services/database.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;
  QuerySnapshot doc1;
  QuerySnapshot doc2;

  Widget searchList() {
    int x = 0;
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (searchSnapshot.docs[index]
                  .data()["searchname"]
                  .toString()
                  .contains(searchTextEditingController.text.toLowerCase()))
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  child: SearchTile(
                    userName: searchSnapshot.docs[index].data()["name"],
                    userEmail: searchSnapshot.docs[index].data()["email"],
                    userImage: searchSnapshot.docs[index].data()["displaypic"],
                  ),
                );
              else {
                x++;
                return x == (searchSnapshot.docs.length)
                    ? Container(
                        child: Center(
                            child: Text(
                          'No users found',
                          style: TextStyle(fontFamily: 'Nunito'),
                        )),
                      )
                    : Container();
              }
            },
          )
        : Container();
  }

  String url;

  initiateSearch() {
    databaseMethods.getUsersOnSearch().then((val) {
      setState(() {
        searchSnapshot = val;
      });
      //url = searchSnapshot.docs[0].data()["displaypic"];
    });

    databaseMethods.getUserByUsername(Constants.myName).then((value) {
      setState(() {
        doc1 = value;
      });
    });
  }

//create chatroom
  createChatroomAndStartConversation(
      {String userName, String userEmail, String userImage}) {
    print('${Constants.myName}');
    if (userName != Constants.myName) {
      String chatRoomId =
          getChatRoomId(userEmail, doc1.docs[0].data()["email"]);
      //String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userEmail, doc1.docs[0].data()["email"]];
      //List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                  chatRoomId,
                  userName,
                  // chatRoomId
                  //     .replaceAll("_", "")
                  //     .replaceAll(Constants.myName, ""),
                  userImage)));
    } else {
      print('you cannot send msg to yourself');
    }
  }

  Widget SearchTile({String userName, String userEmail, String userImage}) {
    return SingleChildScrollView(
      child: FadeAnimation(1,Container(
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
                backgroundImage: userImage == ""
                    ? NetworkImage(
                        "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                    : NetworkImage(userImage),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                ),
                // Text(
                //   userEmail,
                //   style: TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                // )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatroomAndStartConversation(
                  userName: userName,
                  userEmail: userEmail,
                  userImage: userImage,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.deepPurple[200], 
                    Colors.deepPurple[500]
                  ]),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.deepPurple[400], Colors.purple[900]])),
        ),
      ),
      body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              FadeAnimation(
                1.5,
                Center(
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(196, 135, 198, .3),
                                  blurRadius: 20,
                                  offset: Offset(20, 20),
                                )
                              ]),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 120.0,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey[200]))),
                            child: TextField(
                              controller: searchTextEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Username",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.deepPurple[300],
                                Colors.purple[900]
                              ]),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 1.0,
                  width: 150.0,
                  color: Colors.deepPurple[50],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(child: searchList()),
            ],
          ),
        ),
      
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
