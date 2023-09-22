import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatMainController extends GetxController{
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email){

    return  firestore.collection('users')
        .doc(email)
        .collection('chats')
        //.orderBy('lastTime',descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String,dynamic>>> studyStream(String name){
    return firestore.collection('studyGroup').doc(name).snapshots();
  }
}