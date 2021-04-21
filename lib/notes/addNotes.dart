
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/books/bookProfile.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/database.dart';

class Addnotes extends StatelessWidget {

  bool isLoading = true;
   DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
   QuerySnapshot snap1;
   QuerySnapshot searchSnapshot;
  TextEditingController title = TextEditingController();
    TextEditingController content = TextEditingController();

  CollectionReference ref= Firestore.instance.collection('notes');

  initSearch() async {
    await databaseMethods.getBookByTitle(bookTitle).then((val) {
      searchSnapshot=val;
      
    });
  }

  
  myuser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      snap1 = val;
    });
  }
  
  

  @override
  Widget build(BuildContext context) {
    myuser();
    initSearch();
    return Scaffold(
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
          'AddNotes',
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              ref.add({
                'title':title.text,
                'content':content.text,
                'uploader': snap1.docs[0].data()["email"],
                'booktitle':searchSnapshot.docs[0].data()["title"],
              }).whenComplete(() => Navigator.pop(context));
            },
            child: Text('Save'),
          )
        ],
      ),
      backgroundColor: Colors.deepPurple[50],
      body: SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        controller: title,
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
                        controller: content,
                        
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
