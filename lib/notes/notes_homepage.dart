import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/notes/addNotes.dart';
import 'package:logophile_final/notes/editNotes.dart';
import 'package:logophile_final/services/database.dart';

class Notes extends StatefulWidget {
  final String bookName;

  const Notes({Key key, this.bookName}) : super(key: key);
  @override
  _NotesState createState() => _NotesState(bookName);
}

class _NotesState extends State<Notes> {
  String bookName;
  _NotesState(this.bookName);

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
                  .data()["booktitle"]
                  .toString()
                  .contains(bookName))
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  child: SearchTile(
                    index: index,
                    body: searchSnapshot.docs[index].data()["content"],
                    title: searchSnapshot.docs[index].data()["title"],
                  ),
                );
              else {
                x++;
                return x == (searchSnapshot.docs.length)
                    ? Container(
                        child: Center(
                            child: Text(
                          'No Notes found',
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

  initiateSearch() {
    databaseMethods.getUserSpecificNotes(Constants.myName).then((val) {
      if (this.mounted) {
        setState(() {
          searchSnapshot = val;
        });
        //url = searchSnapshot.docs[0].data()["displaypic"];
      }
    });
  }

  Widget SearchTile({String title, String body, int index}) {
    return SingleChildScrollView(
        child: FadeAnimation(
      1,
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditNote(
                        docToEdit: searchSnapshot.docs[index],
                      )));
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
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: new TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  body,
                  style: new TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey[00],
                  ),
                ),
              ],
            )),
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
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.deepPurple,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addnotes()));
        },
      ),
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
          "notes",
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
