import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logophile_final/forums/edit_forum.dart';

class ForumNavBar extends StatefulWidget {
  final String forumName;

  const ForumNavBar({Key key, this.forumName}) : super(key: key);
  @override
  _ForumNavBarState createState() => _ForumNavBarState(forumName);
}

class _ForumNavBarState extends State<ForumNavBar> {
    String forumName;
  _ForumNavBarState(this.forumName);

  @override
  Widget build(BuildContext context) {
   return Drawer(
      child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    "f/$forumName",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                        color: Colors.purple
                      ),
                ),
              
                ListTile(
                    leading: Icon(Feather.edit),
                    title: Text('Edit Profile',
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                    onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditForum(forumName: forumName,)))
                        }),

                
              ],
            ),
    );
  }
}
