import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logophile_final/helper/constants.dart';
import 'package:logophile_final/helper/helperfunctions.dart';

class DatabaseMethods{
  getUserByUsername(String username) async{
   return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get();
  }
  getUserByUsernameForSearch(String username) async {
    return await FirebaseFirestore.instance.collection("users").where("searchname",isEqualTo: username).get();
  }
  getForumByForumNameForSearch(String forumSearchName) async {
    return await FirebaseFirestore.instance.collection("forum").where("forumSearchName",isEqualTo: forumSearchName).get();
  }
   getForumByForumName(String forumName) async{
   return await FirebaseFirestore.instance.collection("forum").where("forumName",isEqualTo: forumName).get();
  }
  
  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: userEmail).get();
  }
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e){
   print(e.toString());
    });
  }
  getUsersOnSearch() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }
  getForumsOnSearch() async {
    return await FirebaseFirestore.instance.collection("forum").get();
  }
  getBookOnSearch() async{
    return await FirebaseFirestore.instance.collection("books").get();
  }
  getBookByTitle(String title) async{
   return await FirebaseFirestore.instance.collection("books").where("title",isEqualTo: title).get();
  }
  getBookByGenre(String genre) async{
   return await FirebaseFirestore.instance.collection("books").where("genre",isEqualTo: genre).get();
  }
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }
   getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: userName).get();
        //.snapshots();
  }
  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e) {
          print(e.toString());
    });
  }
  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }
  uploadPost(postMap) {
    FirebaseFirestore.instance.collection('feed').add(postMap).catchError((e) {
      print(e.toString());
    });
  }
  uploadPostToForum(postMap) {
    FirebaseFirestore.instance.collection('forumfeed').add(postMap).catchError((e) {
      print(e.toString());
    });
  }
  addToShelf(postMap){
    FirebaseFirestore.instance.collection('shelf').add(postMap).catchError((e) {
      print(e.toString());
    });
  }

  createForum(postMap){
    FirebaseFirestore.instance.collection('forum').add(postMap).catchError((e) {
      print(e.toString());
    });
  }
  updatePost(String username) async{
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users").where("name",isEqualTo: username).get();
    String x = docRef.docs[0].id;
    String y = docRef.docs[0].data()["posts"];
    int z = int.parse(y);
    z = z + 1;
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"posts" : "$z"});
  }

  // deletePost(String username,String id) async{
  //   // QuerySnapshot docRef = await FirebaseFirestore.instance
  //   //     .collection("users").where("name",isEqualTo: username).get();
  //   // String x = docRef.docs[0].id;
  //   // String y = docRef.docs[0].data()["posts"];
  //   // int z = int.parse(y);
  //   // z = z - 1;
  //   FirebaseFirestore.instance.collection("feed").doc(id).delete();
  //   // FirebaseFirestore.instance.collection("users").doc(x)
  //   //     .update({"posts" : "$z"});
  //}
  deletebook(String id) {
    
    
    FirebaseFirestore.instance.collection("shelf").doc(id).delete();
   
        
  }

  deleteforum(String id){
    FirebaseFirestore.instance.collection("forumfeed").doc(id).delete();
  }

  getUserSpecificNotes(String username)async{
      QuerySnapshot docReff = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
       String email = docReff.docs[0].data()["email"];
       return await FirebaseFirestore.instance.collection("notes")
        .where("uploader",isEqualTo: email)
        .get();
  }
  getUserrrrSpecificFeed(String username) async{
    QuerySnapshot doccRefff = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo:username).get();
      String emaill = doccRefff.docs[0].data()['email'];
      return await FirebaseFirestore.instance.collection('feed')
            .where("uploader",isEqualTo: emaill)
            .orderBy('time', descending:true)
            .get();
  }


  // getUserrSpecificFeed(String username) async{
  //    QuerySnapshot docReffff = await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("name",isEqualTo: username).get();
  //   String email = docReffff.docs[0].data()["email"];
  //   print(email);
  //   return await FirebaseFirestore.instance.collection("feed")
  //       .where("uploader",isEqualTo: email)
  //       .orderBy("time",descending: true)
  //       .get();
  // }
//  getUserSpecificFeed(String username) async {
//     QuerySnapshot docRef = await FirebaseFirestore.instance
//         .collection("users")
//         .where("name",isEqualTo: username).get();
//     String email = docRef.docs[0].data()["email"];
//     print(email);
//     return await FirebaseFirestore.instance.collection("feed")
//         .where("uploader",isEqualTo: email)
//         .orderBy("time",descending: true)
//         .get();
//   }
  getForumSpecificFeed(String forumName) async {

    return await FirebaseFirestore.instance.collection("forumfeed")
        .where("forumName",isEqualTo: forumName)
        .orderBy("time",descending: true)
        .get();
  }
  
   getUserSpecificShelf(String username) async {
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
    String email = docRef.docs[0].data()["email"];
    print(email);
    return await FirebaseFirestore.instance.collection("shelf")
        .where("uploader",isEqualTo: email)
        .get();
  }
  
  updateUser(String name,String newUsername,
      String fname,String lname,String bio) async{
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users").where("name",isEqualTo: name).get();
    String x = docRef.docs[0].id;

    if(newUsername != "nochange") {
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"name" : newUsername});
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"searchname" : newUsername.toLowerCase()});
      HelperFunctions.saveUserNameSharedPreference(
          newUsername);
      Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    }
    

    if(fname != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"fname" : fname});

    if(lname != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"lname" : lname});

    if(bio != "nobio")
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"bio" : bio});

  }
  updateForum(String forumName,String bio) async{
    QuerySnapshot docRefff = await FirebaseFirestore.instance
        .collection("forum").where("forumName",isEqualTo: forumName).get();
    String x = docRefff.docs[0].id;

    if(bio != "nobio")
      FirebaseFirestore.instance.collection("forum").doc(x)
          .update({"bio" : bio});

  }
  Future<bool> isUserFollowing(String user,String current) async {

    QuerySnapshot snap;
    snap = await FirebaseFirestore.instance.collection("users")
        .where("name",isEqualTo: current)
        .where("ifollowthem",arrayContains: user).get();
    print(snap.size);
    if(snap.size == 1) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }
  // Future<bool> isUserJoined(String forum,String user) async {

  //   QuerySnapshot snap;
  //   snap = await FirebaseFirestore.instance.collection("forum")
  //       .where("members",arrayContains: user).get();
  //   print(snap.size);
  //   if(snap.size == 1) {
  //     //print('he');
  //     return true;
  //   }
  //   else {
  //     //print('ne');
  //     return false;
  //   }
  // }

   Future toggleFollow(String user,String current,String currentEmail) async {

    QuerySnapshot snap;
    snap = await FirebaseFirestore.instance.collection("users")
        .where("name",isEqualTo: current)
        .where("ifollowthem",arrayContains: user).get();
    //print(snap.size);


    if(snap.size == 1) {
      QuerySnapshot docRef = await FirebaseFirestore.instance
          .collection("users").where("email",isEqualTo: user).get();
      String x = docRef.docs[0].id;
      QuerySnapshot docRef1 = await FirebaseFirestore.instance
          .collection("users").where("name",isEqualTo: current).get();
      String y = docRef1.docs[0].id;

      List p = docRef1.docs[0].data()["ifollowthem"];
      List q = docRef.docs[0].data()["followsme"];

      int m = p.length;
      m = m - 1;
      int n = q.length;
      n = n - 1;

      print(docRef1.docs[0].data()["ifollowthem"]);

      await FirebaseFirestore.instance.collection("users").doc(y)
          .update({"ifollowthem" : FieldValue.arrayRemove([user])});

      await FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followsme" : FieldValue.arrayRemove([currentEmail])});

      FirebaseFirestore.instance.collection("users").doc(y)
          .update({"following" : "$m"});
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followers" : "$n"});
    }
    else {

      QuerySnapshot docRef = await FirebaseFirestore.instance
          .collection("users").where("email",isEqualTo: user).get();
      String x = docRef.docs[0].id;
      QuerySnapshot docRef1 = await FirebaseFirestore.instance
          .collection("users").where("name",isEqualTo: current).get();
      String y = docRef1.docs[0].id;

      List p = docRef1.docs[0].data()["ifollowthem"];
      List q = docRef.docs[0].data()["followsme"];

      int m = p.length;
      m = m + 1;
      int n = q.length;
      n = n + 1;

      print(docRef1.docs[0].data()["ifollowthem"]);

      await FirebaseFirestore.instance.collection("users").doc(y)
          .update({"ifollowthem" : FieldValue.arrayUnion([user])});

      await FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followsme" : FieldValue.arrayUnion([currentEmail])});

      FirebaseFirestore.instance.collection("users").doc(y)
          .update({"following" : "$m"});
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followers" : "$n"});
    }
   }

   getFeed(String username) async {
     QuerySnapshot docRef = await FirebaseFirestore.instance
         .collection("users")
         .where("name",isEqualTo: username).get();
     String email = docRef.docs[0].data()["email"];
     print(email);
     QuerySnapshot snap = await FirebaseFirestore.instance.collection("feed").orderBy("time",descending: true).get();
     List p = docRef.docs[0].data()["ifollowthem"];
     if(p.length>0) {
       // p.add(email);
       // print(p);
       // print(p.length);
       // print(p[0]);
       // print(p[1]);
       // print(snap.docs.length);
       //
       // int i,j;
       // for(i=0;i<p.length;i++)
       //   for(j=0;j<snap.docs.length;j++)
       //     if(snap.docs[j].data()["uploader"] == p[i]) {
       //       print(p[i]);
             return snap;
           //}
             //   return await FirebaseFirestore.instance.collection('feed')
           // .where("uploader",arrayContainsAny: p).get();
     }
     else {
      return await FirebaseFirestore.instance.collection("feed")
          .where("uploader",isEqualTo: email)
          .orderBy("time",descending: true)
          .get();
    }
  }
  getNoOfPosts(String username) async {
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
    String email = docRef.docs[0].data()["email"];
    List p = docRef.docs[0].data()["ifollowthem"];
    QuerySnapshot doc1;
    int i;
    int j=0;
    if(p.length>0){
      p.add(email);
      for(i=0;i<p.length;i++)
        {
          doc1 = await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: p[i]).get();
          j = j + int.parse(doc1.docs[0].data()["posts"]);
        }
      return j;
    }
    else
      return 0;
  }

  getFollowers(String username) async {
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
    String email = docRef.docs[0].data()["email"];
    List p = docRef.docs[0].data()["ifollowthem"];
    p.add(email);
    return p;
  }
  String checking(String username) {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        return result.data()["name"];
      });
    });
  }
}