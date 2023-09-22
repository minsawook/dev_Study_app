import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChangeProfileController extends GetxController{
  late TextEditingController nameC;
  late TextEditingController descC;

  String? profileUrl= '';
  final picker = ImagePicker();
  File? image;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameC = TextEditingController();
    descC = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    image= null;
    profileUrl = null;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameC.dispose();
    descC.dispose();

  }

  Future pickImage() async{
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
  }

  Future uploadImageToFirebase() async {
    try {
      if(image == null) return;
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profileImg/${AuthController.instance.authentication
          .currentUser!.email}');
      await storageReference.putFile(File(image!.path));
      profileUrl = await storageReference.getDownloadURL();

      print('이미지 업로드 완료: $profileUrl');
    } catch (e) {
      print('이미지 업로드 실패: $e');
    }
  }

  Future<void> updateNicknameInUserPosts(String email, String newNickname, url) async {

    // 해당 사용자가 작성한 모든 게시물 가져오기
     QuerySnapshot userPosts = await FirebaseFirestore.instance
        .collection('chats')
        .get();

    for (final QueryDocumentSnapshot post in userPosts.docs) {
      QuerySnapshot mUserPosts = await FirebaseFirestore.instance
          .collection('chats')
          .doc(post.id)
          .collection('chat')
          .where('email', isEqualTo: email)
          .get();

      for (final QueryDocumentSnapshot post2 in mUserPosts.docs) {
        await post2.reference.update({'name': newNickname, 'profileUrl': url});
      }
    }

      userPosts = await FirebaseFirestore.instance
         .collection('studyGroup')
         .get();

    var joinDataList = [];
     for (final QueryDocumentSnapshot post in userPosts.docs) {

       for(var joinData in post['RequestJoin']){
         if(joinData['email'] == email) {
           joinData['name'] = newNickname;
           joinData['profileUrl'] = url;
         }
         joinDataList.add(joinData);
       }
        await FirebaseFirestore.instance
           .collection('studyGroup')
           .doc(post.id)
            .update({'RequestJoin' : joinDataList});

     }




      userPosts = await FirebaseFirestore.instance
        .collection('community')
        .get();

     for (final QueryDocumentSnapshot post in userPosts.docs) {
       if(post['email'] == email)  await post.reference.update({'name': newNickname});

       QuerySnapshot mUserPosts = await FirebaseFirestore.instance
           .collection('community')
           .doc(post.id)
           .collection('comment')
           .get();

       for (final QueryDocumentSnapshot post2 in mUserPosts.docs) {
         if(post2['email'] == email)  await post2.reference.update({'name': newNickname});


         QuerySnapshot nUserPosts = await FirebaseFirestore.instance
             .collection('community')
             .doc(post.id)
             .collection('comment')
             .doc(post2.id)
             .collection('reply')
             .where('email', isEqualTo: email)
             .get();

         for (final QueryDocumentSnapshot post3 in nUserPosts.docs) {
           await post3.reference.update({'name': newNickname});
         }
       }
     }
  }
  }