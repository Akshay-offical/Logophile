import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/database.dart';

class EditForum extends StatefulWidget {
  final String forumName;

  const EditForum({Key key, this.forumName}) : super(key: key);
  @override
  _EditForumState createState() => _EditForumState(forumName);
}

class _EditForumState extends State<EditForum> {
  String forumName;
  _EditForumState(this.forumName);

  File _image;
  File _image1;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnap;

  bool dpChange = false;
  bool tpChange = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController bioTextEditingController = new TextEditingController();

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

      bio = bioTextEditingController.text.isEmpty
          ? "nobio"
          : bioTextEditingController.text;
      databaseMethods.updateForum(forumName, bio);
    }
  }

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
    databaseMethods.getForumByForumName(forumName).then((val) {
      setState(() {
        if (val != null) searchSnap = val;
      });
    });
  }

  uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    initiateSearch();
    // String  = searchSnap.docs[0].data()["email"];
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('forums/$forumName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //var storage = FirebaseStorage.instance.ref();
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      final ref = FirebaseStorage.instance.ref('forums/$forumName');
      var url = await ref.getDownloadURL();
      print(url);
      String id = searchSnap.docs[0].id;
      //print(value);
      FirebaseFirestore.instance
          .collection("forum")
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
    // String useremail = searchSnap.docs[0].data()["email"];
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('forums/timeline_$forumName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image1);
    //var storage = FirebaseStorage.instance.ref();
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      final ref = FirebaseStorage.instance.ref('forums/timeline_$forumName');
      var url = await ref.getDownloadURL();
      print(url);
      String id = searchSnap.docs[0].id;
      //print(value);
      FirebaseFirestore.instance
          .collection("forum")
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
            ? AssetImage("assets/images/profile.png")
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
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: _image1 != null
                        ?
                        //Image.file(_image,fit: BoxFit.fill,)
                        FileImage(File(_image1.path))
                        : currenttp(),
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
                    backgroundImage: _image != null
                        ?
                        //Image.file(_image,fit: BoxFit.fill,)
                        FileImage(File(_image.path))
                        : currentdp(),
                    radius: 70.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
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
                        "Edit Profile Photo",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 90),
                RaisedButton(
                  onPressed: () {
                    //tpChange = true;
                    print(tpChange);
                    getImage1();
                    setState(() {
                      tpChange = true;
                    });
                    //uploadPic1(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  color: Colors.pink,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 100.0,
                      maxHeight: 60.0,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Edit Cover Photo",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
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
                          height: 169,
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
                            controller: bioTextEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Change bio",
                                hintStyle: TextStyle(color: Colors.grey)),

                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
