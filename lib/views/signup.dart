import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logophile_final/Animations/FadeAnimation.dart';
import 'package:logophile_final/helper/authenticate.dart';
import 'package:logophile_final/helper/helperfunctions.dart';
import 'package:logophile_final/services/auth.dart';
import 'package:logophile_final/services/database.dart';
import 'package:logophile_final/views/chatRoomScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  QuerySnapshot searchSnap;
  QuerySnapshot snap;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController FNameTextEditingController =
      new TextEditingController();
  TextEditingController LNameTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      List<String> FollowsMe = [];
      List<String> IFollowThem = [];

      Map<String, dynamic> userInfoMap = {
        "name": userNameTextEditingController.text,
        "fname": FNameTextEditingController.text,
        "lname": LNameTextEditingController.text,
        "email": emailTextEditingController.text,
        "displaypic": "",
        "tpic": "",
        "followers": "0",
        "following": "0",
        "posts": "0",
        "followsme": FollowsMe,
        "ifollowthem": IFollowThem,
        "bio": "",
        "searchname": userNameTextEditingController.text.toLowerCase(),
      };
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
      });
    }
  }

  bool doesExist = false;
  bool emailExist = false;
  checking<bool>(String val) {
    databaseMethods.getUserByUsernameForSearch(val.toLowerCase()).then((value) {
      setState(() {
        print(value);
        searchSnap = value;
      });
    });
    print(searchSnap.size);
    if (searchSnap.size == 1)
      setState(() {
        doesExist = true;
      });
    else
      setState(() {
        doesExist = false;
      });
    print(doesExist);
    return doesExist;
  }

  checkingEmail<bool>(String val) {
    databaseMethods1.getUserByUserEmail(val).then((value) {
      setState(() {
        print(value);
        snap = value;
      });
    });
    print(snap.size);
    if (snap.size == 1)
      setState(() {
        emailExist = true;
      });
    else
      setState(() {
        emailExist = false;
      });
    print(emailExist);
    return emailExist;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 368,
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
                              "Sign Up",
                              style: TextStyle(
                                  color: Color.fromRGBO(49, 39, 79, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            )),
                        SizedBox(
                          height: 6,
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
                                          return val.isEmpty
                                              ? 'Please provide a valid First Name'
                                              : null;
                                        },
                                        controller: FNameTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "First Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (val) {
                                          return val.isEmpty
                                              ? 'Please provide a valid Last Name'
                                              : null;
                                        },
                                        controller: LNameTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Last Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        onChanged: checking,
                                        validator: (val) => val.isEmpty ||
                                                val.indexOf(" ") >= 0
                                            ? 'Please provide valid username'
                                            : checking(val)
                                                ? 'Username already exists'
                                                : null,
                                        controller:
                                            userNameTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Username",
                                            hintStyle:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        onChanged: checkingEmail,
                                        validator: (val) =>
                                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(val)
                                                ? checkingEmail(val) == false
                                                    ? null
                                                    : 'Email is already in use'
                                                : 'Please provide valid email',
                                        controller: emailTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        obscureText: true,
                                        validator: (val) {
                                          return val.length >= 6
                                              ? null
                                              : 'Please provide password with atleast 6 characters';
                                        },
                                        controller:
                                            passwordTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                            hintStyle:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                            1.9,
                            GestureDetector(
                              onTap: () {
                                signMeUp();
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
                                    "Register",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            2,
                            Center(
                                child: GestureDetector(
                                    onTap: () {
                                      widget.toggle();
                                    },
                                    child: Text(
                                      "Log in",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(49, 39, 79, .6)),
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
