import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/views/commonShelf_details.dart';

class CommonShelf extends StatefulWidget {
   final String userName;
   final String Fname;

  const CommonShelf({Key key, this.userName,this.Fname}) : super(key: key);
  @override
  _CommonShelfState createState() => _CommonShelfState(userName,Fname);
}

class _CommonShelfState extends State<CommonShelf> {
  String userName;
  String Fname;

  _CommonShelfState(this.userName, this.Fname);
  
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
          "${Fname}'s Shelf",
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommonShelfDetails(shelf: 'completed', userName: userName,)));
                },
                child: Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.deepPurple[400], Colors.pink]),
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
                          'Read Shelf',
                          style: TextStyle(color: Colors.white, fontSize: 19),
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
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommonShelfDetails(shelf: 'reading', userName: userName,)));
                },
                child: Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.deepPurple[400], Colors.pink]),
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
                          'Reading Shelf ',
                          style: TextStyle(color: Colors.white, fontSize: 19),
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
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommonShelfDetails(shelf: 'wishlist', userName: userName,)));
                },
                child: Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.deepPurple[400], Colors.pink]),
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
                          'Wishlist',
                          style: TextStyle(color: Colors.white, fontSize: 19),
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
            ],
          ),
        ),
      ),
    );
  }
}
