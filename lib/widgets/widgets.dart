import 'package:flutter/material.dart';

Widget appBarMain(BuildContext) {
  return AppBar(
    backgroundColor: Colors.purple,
    title: Text(
      'Logophile',
      style: TextStyle(
        fontFamily: "Signatra",
        fontSize: 30.0,
        color: Colors.white,
      ),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
}