import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CommunityMainController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot<Map<String, dynamic>>> communityStream(){

    return  firestore.collection('community')
        .orderBy('time',descending: true)
        .snapshots();
  }
}