import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/database.dart';

import 'forum_display.dart';

class ForumUpload extends StatefulWidget {
  final String forumName;

  ForumUpload(this.forumName);
  @override
  _ForumUploadState createState() => _ForumUploadState(forumName);
}

class _ForumUploadState extends State<ForumUpload> {
  String forumName;
  _ForumUploadState(this.forumName);
   AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snap;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleTextEditingController =
      new TextEditingController();
  TextEditingController bodyTextEditingController = new TextEditingController();
  TextEditingController tagTextEditingController = new TextEditingController();

 post() {
    if (formKey.currentState.validate()) {
      // if(databaseMethods.doesUserExist(userNameTextEditingController.text) == null) {
      Map<String, dynamic> postMap = {
        "title": titleTextEditingController.text,
        "body": bodyTextEditingController.text,
        "tag": tagTextEditingController.text.isEmpty
            ? ""
            : tagTextEditingController.text,
        "uploader": snap.docs[0].data()["email"],
        "time": DateTime.now().millisecondsSinceEpoch,
        "forumName": forumName,
      };
      databaseMethods.uploadPostToForum(postMap);
      // databaseMethods.updatePost(Constants.myName);
     forumNameIs(forumName);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ForumDisplay()));
    }
  }
   myuser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      snap = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    myuser();
    return Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(Icons.close_rounded, size: 35),
            tooltip: 'Back to Home',
            onPressed: () {
              Navigator.pop(
                context
              );
            },
          ),
          toolbarHeight: 69,
          title: Text(
            'Create Your Forum',
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
          // actions: <Widget>[
          //   IconButton(
          //     icon: new Icon(
          //       MaterialIcons.add_a_photo,
          //       size: 35,
          //     ),
          //     tooltip: 'Post',
          //     onPressed: () {},
          //   ),
          // ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Colors.deepPurple[400],
                  Colors.purple[900]
                ])),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                //height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Form(
                      key: formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          height: 40.0,
                        ),
                        FadeAnimation(
                          1,
                          Container(
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
                            child: TextFormField(
                              validator: (val) {
                                return val.isEmpty
                                    ? 'Please provide a valid Post Title'
                                    : null;
                              },
                              controller: titleTextEditingController,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.black,
                                  fontSize: 20),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Title",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80.0,
                          width: 1000.0,
                        ),
                        FadeAnimation(
                          1,
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 450,
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
                            child: TextFormField(
                              maxLines: 12,
                              controller: bodyTextEditingController,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.black,
                                  fontSize: 20),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Body",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70.0,
                          width: 1000.0,
                        ),
                        FadeAnimation(
                          1,
                          ButtonTheme(
                              minWidth: 200.0,
                              height: 50.0,
                              child: RaisedButton(
                                child: const Text('Upload Post',
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Nunito')),
                                onPressed: () {
                                  post();
                                },
                                color: Colors.deepPurple,
                                disabledColor:
                                    Colors.blue, //remove when onPressed is used
                                textColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                splashColor: Colors.blue,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ]),
                    )))));
  }
}
