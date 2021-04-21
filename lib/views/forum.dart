import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/animating_search.dart';
import 'package:logophile_final/books/search_book.dart';
import 'package:logophile_final/forums/search_forums.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
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
        title: Center(
          child: Text(
            'Library',
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Center(
            child: AddForumButton()
            ),
          
         
          
          Expanded(
                      child: Container(
                      child: Center(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(
                                image: AssetImage('assets/images/forum.png'),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:40.0),
                              child: Text(
                                "Forums are groups which help you find other users with common interests",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                                'Search for a forum or create one yourself'),
                                SizedBox(height:25),
                            AnimatedSearchBar(page: SearchForums(),)
                          ],
                        ),
                      )),
                    ))

        ],
      ),
    );
  }
}
