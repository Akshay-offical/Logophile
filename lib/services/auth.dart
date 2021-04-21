import 'package:firebase_auth/firebase_auth.dart';
import 'package:logophile_final/model/model.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Userr _userFromFirebaseUser(User user) {
    return user !=null ? Userr(userId: user.uid) : null;
  }
  Future signInWithEmailAndPassword(String email,String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      if(firebaseUser.emailVerified)
      return _userFromFirebaseUser(firebaseUser);
      else {
        print("not verified");
        return "notv";
      }

    }
    catch(e){
    print(e.toString());
    print("wrong pw");
    return "nop";
    }
  }
  Future signUpWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      User firebaseUser = result.user;
     await firebaseUser.sendEmailVerification();
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e) {
      print(e.toString());
    }
  }
   Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e) {
      print(e.toString());
    }
    
  }
   Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
    }
  }
}

