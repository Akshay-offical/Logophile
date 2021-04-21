import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/books/book_alert.dart';

import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/notes/notes_homepage.dart';
import 'package:logophile_final/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

String bookTitle;
void titleIs(String title) {
  bookTitle = title;
}

class BookProfile extends StatefulWidget {
  @override
  _BookProfileState createState() => _BookProfileState();
}

class _BookProfileState extends State<BookProfile> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot snap;
  QuerySnapshot snap1;

  DatabaseMethods databaseMethods10 = new DatabaseMethods();
  QuerySnapshot searchSnapshot10;

  QuerySnapshot doc1;

  String image;
  String title;
  String title1;
  String author;
  String rating;
  String genre;
  String desc;
  String link;
  bool isLoading = true;

  initSearch() async {
    await databaseMethods.getBookByTitle(bookTitle).then((val) {
      if (mounted) {
        setState(() {
          searchSnapshot = val;
        });
      }
    });
    title = searchSnapshot.docs[0].data()["title"];
    image = searchSnapshot.docs[0].data()["image"];
    title1 = searchSnapshot.docs[0].data()["searchtitle"];
    author = searchSnapshot.docs[0].data()["author"];
    genre = searchSnapshot.docs[0].data()["genre"];

    rating = searchSnapshot.docs[0].data()["rating"].toString();
    desc = searchSnapshot.docs[0].data()["desc"];
    link = searchSnapshot.docs[0].data()["link"];

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  myuser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      snap1 = val;
    });
  }

  add(shelf) {
    Map<String, dynamic> postMap = {
      "title": title,
      'image': searchSnapshot.docs[0].data()["image"],
      'author': searchSnapshot.docs[0].data()["author"],
      "uploader": snap1.docs[0].data()["email"],
      "type": shelf,
      "rating": searchSnapshot.docs[0].data()["rating"].toString(),
    };
    databaseMethods.addToShelf(postMap);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget readButton = FlatButton(
      child: Text(
        "Read Shelf",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        add('completed');
        Navigator.of(context).pop();
      },
    );
    Widget readingButton = FlatButton(
        child: Text(
          "Reading Shelf",
          style: TextStyle(color: Colors.deepPurple),
        ),
        onPressed: () {
          add('reading');
          Navigator.of(context).pop();
        });
    Widget wishlistButton = FlatButton(
      child: Text(
        "Wishlist",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        add('wishlist');
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Icon(Icons.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Text(
            "Adding this to shelf",
          ),
          cancelButton,
        ],
      ),
      content: Text("which shelf do you like to add this book to?"),
      actions: [
        readButton,
        readingButton,
        wishlistButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    myuser();
    initSearch();
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: isLoading
          ? AppBar(
              toolbarHeight: 69,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.deepPurple[400], Colors.pink])),
              ),
            )
          : AppBar(
              title: Text(
                title1,
                style: TextStyle(
                  fontFamily: "Signatra",
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ),
              toolbarHeight: 69,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.deepPurple[400], Colors.pink])),
              ),
            ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 370,
                      height: 480,
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
                            height: 60,
                          ),
                          Expanded(
                            child: Container(
                              height: 225,
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.redAccent, width: 3),
                                image: DecorationImage(
                                    alignment: Alignment.topCenter,
                                    image: NetworkImage(image),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(author,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[500],
                              )),
                          SizedBox(
                            height: 7,
                          ),
                          Text('${rating} ⭐',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[500],
                              )),
                          SizedBox(
                            height: 17,
                          ),
                          Text('Genre: $genre',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[900],
                              )),
                          SizedBox(
                            height: 17,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Get Your Copy Here",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[900],
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url = '$link';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not lauch $url';
                                  }
                                },
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // RaisedButton(
                      //   onPressed: () {},
                      //   color: Colors.deepPurple,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(80.0),
                      //   ),
                      //   child: Container(
                      //     constraints: BoxConstraints(
                      //       maxWidth: 100.0,
                      //       maxHeight: 40.0,
                      //     ),
                      //     alignment: Alignment.center,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           child: Text(
                      //             "Bookmark",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontFamily: 'Nunito',
                      //                 fontSize: 11.0,
                      //                 letterSpacing: 2.0,
                      //                 fontWeight: FontWeight.w300),
                      //           ),
                      //         ),
                      //         Icon(
                      //           Icons.bookmark_border_outlined,
                      //           color: Colors.white,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Notes(bookName: bookTitle,)));
                        },
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            maxHeight: 40.0,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " Notes",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 11.0,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w300),
                              ),
                              Icon(
                                Icons.notes,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Colors.deepPurple[400],
                                Colors.pink
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ]),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add to your Shelf',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Icon(
                              CupertinoIcons.book,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                          'Overview',
                          style: TextStyle(
                            fontSize: 36,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              desc,
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
                  SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
