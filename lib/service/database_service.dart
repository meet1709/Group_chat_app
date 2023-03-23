import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  //reference for our collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //saving user data

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilepic": "",
      "uid": uid
    });
  }

  //getting user data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //crearting a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    //update the members
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupdocumentReference.id,
    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);

    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }

  //getting chats

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();

    return documentSnapshot['admin'];



  }


  //get group Members

  getGroupMembers(groupId) async{

    return groupCollection.doc(groupId).snapshots();


  }

  //search

  SearchByName(String groupName)
  {
    return groupCollection.where("groupName" , isEqualTo: groupName).get();
  }


  //return bool
  Future<bool> isUserJoined(String groupName , String groupId , String userNAme)
async{
  DocumentReference userDocumenrtReference = userCollection.doc(uid);
  DocumentSnapshot documentSnapshot = await userDocumenrtReference.get();



  List<dynamic> groups = await documentSnapshot['groups'];
  

  if(groups.contains("${groupId}_$groupName")){

    return true;
  }
  else
  {
    return false;
  }





}

  //toggling the group join and exit

  Future toggleGroupJoin(String groupId , String userName , String groupName) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference =groupCollection.doc(groupId);


    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    
  List<dynamic> groups = await documentSnapshot['groups'];


  //if user has our grouo -> then remove then or also in other part re join
  if(groups.contains("${groupId}_$groupName"))
  {
    await userDocumentReference.update({
      "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"]),

    });

    await groupDocumentReference.update({
      "members" : FieldValue.arrayRemove(["${uid}_$userName"]),

    });
    
    
  }
  else
  {

    await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"]),

    });

    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${uid}_$userName"]),

    });
    






  }






  }



  //send message
  sendMessage(String groupId , Map<String , dynamic> chatMessageData) async{

    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({

      "recentMessage": chatMessageData['message'],
      "recentMessageSender":chatMessageData['sender'],
      "recentMessageTime":chatMessageData['time'].toString(),


    });



  }




}
