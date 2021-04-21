import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/auth.dart';

import 'package:logophile_final/services/bottombar.dart';
import 'package:logophile_final/services/database.dart';

class CreateForum extends StatefulWidget {
  @override
  _CreateForumState createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {

  bool isLoading = false;
  QuerySnapshot searchSnap;
  QuerySnapshot snap;
  QuerySnapshot snap1;
  QuerySnapshot searchSnapshot;
  bool dpChange = false;
  bool tpChange = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController forumNameTextEditingController =
      new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();

  myuser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      snap1 = val;
    });
  }

  addForum() {
    if (formKey.currentState.validate()) {
      List<String> Members = [];

      Map<String, dynamic> forumMap = {
        "forumName": forumNameTextEditingController.text,
        "bio": bioTextEditingController.text,
        "displaypic": "",
        "tpic": "",
        "admin": snap1.docs[0].data()["email"],
        "members": Members,
        "memberCount": "0",
        "forumSearchName": forumNameTextEditingController.text.toLowerCase(),
      };
      databaseMethods.createForum(forumMap);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBar()));
    }
  }

  bool doesExist = false;

  checking<bool>(String val) {
    databaseMethods
        .getForumByForumNameForSearch(val.toLowerCase())
        .then((value) {
      setState(() {
        print(value);
        searchSnap = value;
      });
    });
    print(searchSnap.size);
    if (searchSnap.size == 1) if (this.mounted) {
      setState(() {
        doesExist = true;
      });
    } else if (this.mounted) {
      setState(() {
        doesExist = false;
      });
    }
    print(doesExist);
    return doesExist;
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
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => BottomBar(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            },
          ),
          toolbarHeight: 69,
          title: Text(
            'Create a Forum',
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
            child: Column(
              children: [
                Container(
            decoration: BoxDecoration(
                // image: DecorationImage(
                //     image: _image1 != null
                //         ?
                //         //Image.file(_image,fit: BoxFit.fill,)
                //         FileImage(File(_image1.path))
                //         : currenttp(),
                //     fit: BoxFit.cover)
                    ),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                // child: CircleAvatar(
                //   backgroundImage: _image != null
                //       ?
                //       //Image.file(_image,fit: BoxFit.fill,)
                //       FileImage(File(_image.path))
                //       : currentdp(),
                //   radius: 70.0,
                // ),
              ),
            ),
          ),
                Container(
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
                                  
                                  validator: (val) =>
                                      val.isEmpty || val.indexOf(" ") >= 0
                                          ? 'Please provide valid forum name'
                                          : checking(val)
                                              ? 'forum name already exists'
                                              : null,
                                  controller: forumNameTextEditingController,
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.black,
                                      fontSize: 20),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Forum Name",
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
                                height: 200,
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
                                  controller: bioTextEditingController,
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.black,
                                      fontSize: 20),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Bio",
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
                                      addForum();
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
                        ))),
              ],
            )));
  }
}
