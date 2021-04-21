import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/animating_search.dart';
import 'package:logophile_final/books/search_book.dart';
import 'package:logophile_final/views/search.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
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
            child: CategoryButton()
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
                                image: AssetImage('assets/images/library.png'),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              "Welcome to Logohiles's extensive library",
                            ),
                            Text(
                                'Search for a book to get started'),
                                SizedBox(height:25),
                            AnimatedSearchBar(page: SearchBooks(),)
                          ],
                        ),
                      )),
                    ))

        ],
      ),
    );
  }
}
