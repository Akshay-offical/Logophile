import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/database.dart';

import 'chatroomscreen.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String roomname;
  final String url;

  ConversationScreen(this.chatRoomId, this.roomname, this.url);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot snap;
  TextEditingController messageController = new TextEditingController();
  String myEmail = "";
  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data()["message"],
                      snapshot.data.documents[index].data()["sendBy"] ==
                          myEmail);
                  //Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": myEmail,
        //Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    myUser();
    super.initState();
  }

  myUser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    myEmail = await HelperFunctions.getUserEmailSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.deepPurple[400], Colors.purple[900]])),
        ),
        toolbarHeight: 69,
        title: Row(
          children: [
            Container(
              height: 55.0,
              width: 55.0,
              alignment: Alignment.center,

              child: CircleAvatar(
                backgroundImage: widget.url == ""
                    ? NetworkImage(
                        "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                    : NetworkImage(widget.url),
                radius: 90.0,
              ),
              // Text("${widget.roomname.substring(0,1).toUpperCase()}",
              //   style: mediumTextFieldStyle(),
              // ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              widget.roomname,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff2a4f98),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 90.0),
                child: ChatMessageList()),
            SizedBox(
              height: 100.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                //color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                    
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 69,
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
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send a message",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                  color: Colors.white,))
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(
              left: isSendByMe ? 40.0 : 20.0, right: isSendByMe ? 20.0 : 40.0),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width,
          alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
                color: isSendByMe ? Colors.deepPurple[300] : Colors.teal[200],
                borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23.0),
                        topRight: Radius.circular(23.0),
                        bottomLeft: Radius.circular(23.0),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(23.0),
                        topRight: Radius.circular(23.0),
                        bottomRight: Radius.circular(23.0),
                      )),
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white, fontSize: 17.0, fontFamily: 'Nunito'),
            ),
          ),
        ),
      ],
    );
  }
}
