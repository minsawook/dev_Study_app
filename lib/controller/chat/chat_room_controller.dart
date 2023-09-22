import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatRoomController extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late FocusNode focusNode;
  late TextEditingController chatC;
  int totalUnread = 0;

  late ScrollController scrollController;
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChat(String chatId){
    CollectionReference chats =firestore.collection("chats");
    
    return chats.doc(chatId)
        .collection("chat")
        .orderBy("time",descending: true)
        .snapshots();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    focusNode = FocusNode();
    chatC = TextEditingController();
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    chatC.dispose();
    scrollController.dispose();
    super.dispose();
  }


  Future<void> newChat(String chatId, String chat, {bool isPhoto = false})
  async {
    var date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    
    await chats.doc(chatId).collection("chat").add({
        "email" : AuthController.instance.authentication.currentUser!.email,
        "message" : chat,
        "time" : date,
        "isPhoto" : isPhoto,
        'name' : AuthController.instance.userModel.value.name,
        "profileUrl" : AuthController.instance.userModel.value.profileUrl?? ""
    });


    CollectionReference users = firestore.collection("users");

    List connection = [];

    await chats.doc(chatId).get().then((value) => connection = (value.data()
        as Map<String,dynamic>)['connection']);

    connection.forEach((element) async {
      int totalUnread = 0;
      await users.doc(element).collection('chats').doc
        (chatId).get().then((value) => totalUnread = value.data()!["totalUnread"]);


       users.doc(element).collection('chats').doc(chatId).update({
        "lastChat" : chat,
        'lastTime' : date,
         if(element != AuthController.instance.authentication.currentUser!
             .email) "totalUnread" : ++totalUnread
      });
    });

    chatC.text = "";
  }

  Future pickImage(String chatId,) async{
    String profileUrl= '';
    final picker = ImagePicker();
    File? image;

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if(croppedFile !=null){
        image = File(croppedFile.path);
      }
    } else {
      print('이미지 선택 취소');
    }
    update();

    try {
      if(image == null) return;
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('chatImg/')
          .child('${chatId}/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putFile(File(image!.path));
      profileUrl = await storageReference.getDownloadURL();
      newChat(chatId,profileUrl,isPhoto: true);
      print('이미지 업로드 완료: $profileUrl');
    } catch (e) {
      print('이미지 업로드 실패: $e');
    }
  }

  readChat(String chatId) async {
    CollectionReference users = firestore.collection("users");

    await users.doc(AuthController.instance.userModel.value.email).collection
      ("chats").doc(chatId).update({
      "totalUnread" : 0
    });
  }
}