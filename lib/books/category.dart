import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logophile_final/books/category_display.dart';
import 'package:logophile_final/profile/profileui2.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          'Categories',
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Container(
        
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                       Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Adventure')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/Adventure1.jpg',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Adventure',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Fantasy')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/Fantasy1.jpg',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Fantasy',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                 SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Horror')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/Horror1.jpg',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Horror',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                 SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Mystery')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/Mystery1.jpg',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Mystery',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                 SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Romance')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/Romance1.png',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Romance',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                 SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Sci-Fi')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/SciFi1.jpg',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Sci Fi',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width:30
                ),
                GestureDetector(
                  onTap: () {
                   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CategoryBookDisplay(genre:'Biography')));
                  },
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              'assets/images/genreTile/Biography1.jpg',
                            ),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(69),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: 552,
                      ),
                      Text(
                        'Non-Fiction',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                    ]),
                  ),
                ),
                 SizedBox(
                  width:30
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String image;
  final String categoryName;

  const CategoryCard({Key key, this.image, this.categoryName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
