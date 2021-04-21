import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/books/bookProfile.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/services/database.dart';

class MyShelfDetails extends StatefulWidget {
  final String shelf;
  DocumentSnapshot docToDelete;
  
  

  MyShelfDetails({Key key, this.shelf,this.docToDelete}) : super(key: key);
  @override
  _MyShelfDetailsState createState() => _MyShelfDetailsState(shelf);
}

class _MyShelfDetailsState extends State<MyShelfDetails> {
  String shelf;
  _MyShelfDetailsState(this.shelf);
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  DatabaseMethods databaseMethods2 = new DatabaseMethods();
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
                  .data()["type"]
                  .toString()
                  .contains(shelf))
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  child: SearchTile(
                    bookTitle: searchSnapshot.docs[index].data()["title"],
                    title: searchSnapshot.docs[index].data()["title"],
                    // userEmail: searchSnapshot.docs[index].data()["email"],
                    image: searchSnapshot.docs[index].data()["image"],
                    author: searchSnapshot.docs[index].data()["author"],
                    rating:
                        searchSnapshot.docs[index].data()["rating"].toString(),
                    id: searchSnapshot.docs[index].id
                  ),
                );
              else {
                x++;
                return x == (searchSnapshot.docs.length)
                    ? Container(
                        child: Center(
                            child: Text(
                          'No books found',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                          ),
                        )),
                      )
                    : Container();
              }
            },
          )
        : Container();
  }
  deleteBook(String id){
    databaseMethods2.deletebook(id);
  }


  showAlertDialogBox(BuildContext context, String id) {
    Widget cancelbutton = FlatButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.of(context,).pop();
      },
    );
    Widget deleteButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        deleteBook(id);
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete",
      ),
      content: Text("Delete this book from this shelf"),
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

  initiateSearch() {
    databaseMethods.getUserSpecificShelf(Constants.myName).then((val) {
      if (this.mounted) {
        setState(() {
          searchSnapshot = val;
        });
        //url = searchSnapshot.docs[0].data()["displaypic"];
      }
    });
  }

  Widget SearchTile(
      {String bookTitle,
      String title,
      String image,
      String author,
      String rating,
      String id}) {
    return SingleChildScrollView(
        child: FadeAnimation(
      1,
      GestureDetector(
        onTap: () {
          titleIs(bookTitle);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BookProfile()));
        },
        onLongPress: () {
          showAlertDialogBox(context, id);
        },
        child: Container(
          height: 225,
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
          // padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 3),
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: NetworkImage(image),
                        fit: BoxFit.fitWidth),
                  ),
                ),
              ),
              // Text("${userName.substring(0,1).toUpperCase()}",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 25.0,
              //   ),
              // ),

              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 22, fontFamily: 'Nunito'),
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
                        ))
                  ],
                ),
              ),
              SizedBox(width: 10)
            ],
          ),
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
    initiateSearch();
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
          "$shelf shelf",
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(children: [
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
        ]),
      ),
    );
  }
}
