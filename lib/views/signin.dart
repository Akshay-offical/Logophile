import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/bottombar.dart';
import 'package:logophile_final/services/database.dart';
import 'package:logophile_final/views/chatRoomScreen.dart';
import 'package:logophile_final/views/signup.dart';
import 'package:logophile_final/widgets/widgets.dart';

import 'forgetpassword.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool epCorrect = true;
  bool isVerified = true;
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].data()["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        //if(val != null)
        if (val != "notv" && val != "nop" && val != null) {
          setState(() {
            epCorrect = true;
            isVerified = true;
          });
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomBar()));
        } else {
          print("wrong email/passsword");
          if (val == "notv")
            setState(() {
              isVerified = false;
              epCorrect = true;
            });
          else if (val == "nop") {
            setState(() {
              epCorrect = false;
              isVerified = true;
            });
          }
        }
      });
    }
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background-2.png'),
                                  fit: BoxFit.fill)),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Container(
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
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val)
                                        ? null
                                        : 'Please provide valid email';
                                  },
                                  controller: emailTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (val) {
                                    return val.length > 0
                                        ? null
                                        : 'Wrong password';
                                  },
                                  controller: passwordTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  epCorrect == false
                      ? Text(
                          "Email / Password is wrong or doesn't exist!",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.red,
                            fontSize: 17.0,
                          ),
                        )
                      : Container(),
                  epCorrect == false
                      ? SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  isVerified == false
                      ? Text(
                          "Email hasn't been verified!",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.red,
                            fontSize: 17.0,
                          ),
                        )
                      : Container(),
                  isVerified == false
                      ? SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  FadeAnimation(
                      1.7,
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color.fromRGBO(196, 135, 198, 1)),
                        ),
                      ))),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.9,
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromRGBO(49, 39, 79, 1),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      2,
                      Center(
                          child: GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, .6)),
                              )))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
