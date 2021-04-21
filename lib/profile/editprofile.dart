import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/database.dart';

class edit extends StatefulWidget {
  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  File _image;
  File _image1;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnap;

  bool dpChange = false;
  bool tpChange = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController newuserNameTextEditingController =
      new TextEditingController();
  TextEditingController newFNameTextEditingController =
      new TextEditingController();
  TextEditingController newLNameTextEditingController =
      new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();

  String userName;
  String batch;
  String Fname;
  String Lname;
  String bio;

  void initState() {
    getinfo();
    super.initState();
  }

  getinfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  editProfile() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    print(Constants.myName);

    if (formKey.currentState.validate()) {
      print('hello');
      userName = newuserNameTextEditingController.text.isEmpty
          ? "nochange"
          : newuserNameTextEditingController.text;

      Fname = newFNameTextEditingController.text.isEmpty
          ? "nochange"
          : newFNameTextEditingController.text;
      print(Fname);
      Lname = newLNameTextEditingController.text.isEmpty
          ? "nochange"
          : newLNameTextEditingController.text;
      print(Lname);
      bio = bioTextEditingController.text.isEmpty
          ? "nobio"
          : bioTextEditingController.text;
      databaseMethods.updateUser(Constants.myName, userName, Fname, Lname, bio);
    }
  }

  bool doesExist = false;

  checking<bool>(String val) {
    databaseMethods.getUserByUsernameForSearch(val.toLowerCase()).then((value) {
      setState(() {
        print(value);
        searchSnapshot = value;
      });
    });
    if (searchSnapshot != null) {
      print(searchSnapshot.size);
      if (searchSnapshot.size == 1)
        setState(() {
          doesExist = true;
        });
      else
        setState(() {
          doesExist = false;
        });
      print(doesExist);
      return doesExist;
    } else
      return false;
  }

  // dpChange = false;
  // tpChange = false;

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print("hello ji");
      print("Image Path $_image");
      dpChange = true;
      print(dpChange);
    });
  }

  getImage1() async {
    var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image1 = image1;
      print("hello ji");
      print("Image Path $_image1");
      tpChange = true;
      print(tpChange);
    });
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        if (val != null) searchSnap = val;
      });
    });
  }

  uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    initiateSearch();
    String useremail = searchSnap.docs[0].data()["email"];
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('users/$useremail');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //var storage = FirebaseStorage.instance.ref();
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      final ref = FirebaseStorage.instance.ref('users/$useremail');
      var url = await ref.getDownloadURL();
      print(url);
      String id = searchSnap.docs[0].id;
      //print(value);
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"displaypic": url});
      setState(() {
        // print("Profile picture uploaded");
        //storage.child('gs://campconnectchat.appspot.com/users/$useremail').getDownloadURL().then((value) {

        //});
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text('Profile picture uploaded'),
        // ));
        dpChange = true;
        if (tpChange)
          uploadPic1(context);
        else
          Navigator.pop(context);
      });
    });
  }

  uploadPic1(BuildContext context) async {
    String fileName = basename(_image1.path);
    initiateSearch();
    String useremail = searchSnap.docs[0].data()["email"];
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('users/timeline_$useremail');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image1);
    //var storage = FirebaseStorage.instance.ref();
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      final ref = FirebaseStorage.instance.ref('users/timeline_$useremail');
      var url = await ref.getDownloadURL();
      print(url);
      String id = searchSnap.docs[0].id;
      //print(value);
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"tpic": url});
      //});
      setState(() {
        // print("Timeline picture uploaded");
        //storage.child('gs://campconnectchat.appspot.com/users/$useremail').getDownloadURL().then((value) {

        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text('Profile picture uploaded'),
        // ));
        tpChange = true;
        Navigator.pop(context);
      });
    });
  }

  currentdp() {
    initiateSearch();
    return searchSnap != null
        ? searchSnap.docs[0].data()["displaypic"] == ""
            ? NetworkImage(
                "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
            : NetworkImage(searchSnap.docs[0].data()["displaypic"])
        : NetworkImage(
            "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png");
  }

  currenttp() {
    initiateSearch();
    return searchSnap != null
        ? searchSnap.docs[0].data()["tpic"] == ""
            ? NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg")
            : NetworkImage(searchSnap.docs[0].data()["tpic"])
        : NetworkImage(
            "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg");
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
                    colors: <Color>[Colors.deepPurple[400], Colors.pink])),
          ),
          title: Text(
            'Edit',
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 450,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/profile.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                width: double.infinity,
                height: 200,
                child: Container(
                  alignment: Alignment(0.0, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 34,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.pink,
                        radius: 65,
                        child: CircleAvatar(
                          backgroundImage: _image != null
                              ?
                              //Image.file(_image,fit: BoxFit.fill,)
                              FileImage(File(_image.path))
                              : currentdp(),
                          radius: 63.0,
                        ),
                      ),
                      SizedBox(
                        width: 49,
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            //dpChange = true;
                            print(dpChange);
                            setState(() {
                              dpChange = true;
                            });
                            getImage();
                            //uploadPic(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          color: Colors.pink,
                          child: Ink(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 100.0,
                                maxHeight: 60.0,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Change DP",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
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
                              return null;
                            },
                            controller: newFNameTextEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Change First name",
                                hintStyle: TextStyle(color: Colors.grey)),

                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                              return null;
                            },
                            controller: newLNameTextEditingController,
                            style: TextStyle(fontFamily: 'Nunito'),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Change Last name",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(
                          height: 60.0,

                        ),
                        GestureDetector(
                          onTap: () async {
                            await editProfile();
                            print(dpChange);
                            print(tpChange);
                            //dpChange ?
                            if (dpChange) await uploadPic(context);
                            //: null;
                            //tpChange ? await
                            if (tpChange) await uploadPic1(context);
                            //: null;
                            print("updation done");
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromRGBO(49, 39, 79, 1),
                            ),
                            child: Center(
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ])));
  }
}
