import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/component/loading.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class CommunityInfoController extends GetxController{

  late TextEditingController commentC;
  RxBool isReply = false.obs;
  RxString replyName = ''.obs;
  String commentId = '';
  late FocusNode focusNode;

  String imgUrl= "";
  final picker = ImagePicker();
  var argument;
  @override
  void onInit() {
    // TODO: implement onInit
    commentC = TextEditingController();
    focusNode = FocusNode();
    argument = Get.arguments;

    viewCountIncrease();
    super.onInit();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    commentC.dispose();
    focusNode.dispose();
    super.dispose();
  }


  FirebaseFirestore firestore = FirebaseFirestore.instance;



  Stream<DocumentSnapshot<Map<String, dynamic>>> communityStream( ){
    return  firestore.collection('community')
        .doc(argument['id'])
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> commentStream( ){
    return  firestore.collection('community')
        .doc(argument['id'])
        .collection('comment')
        .orderBy('time',/*descending: true*/)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> replyStream(commentId){
    return  firestore.collection('community')
        .doc(argument['id'])
        .collection('comment')
        .doc(commentId)
        .collection('reply')
        .orderBy('time', /*descending: true*/)
        .snapshots();
  }


  void viewCountIncrease(){
    firestore.collection('community')
        .doc(argument['id']).get().then((value) {
          int count = value['viewCount'];
      firestore.collection('community')
          .doc(argument['id']).update({
        'viewCount' :  count +1
      });
    });
  }

  void commentCountIncrease(){
    firestore.collection('community')
        .doc(argument['id']).get().then((value) {
      int count = value['commentCount'];
      firestore.collection('community')
          .doc(argument['id']).update({
        'commentCount' :  count +1
      });
    });
  }

  void commentCountDecrease(){
    firestore.collection('community')
        .doc(argument['id']).get().then((value) {
      int count = value['commentCount'];
      firestore.collection('community')
          .doc(argument['id']).update({
        'commentCount' :  count -1
      });
    });
  }

  Future<void> writeComment() async {

    await uploadImageToFirebase();

    firestore.collection('community')
        .doc(argument['id'])
        .collection("comment").add({
          "email" : AuthController.instance.authentication.currentUser!.email,
          "name" : AuthController.instance.userModel.value.name,
          'time' : DateTime.now().toIso8601String(),
          'text' : commentC.text,
          'imageUrl' : imgUrl
    });
    commentCountIncrease();
    setReply("",false,"");
    commentC.text = "";
    imgUrl = "";
  }


  Future<void> writeReply() async {

    await uploadImageToFirebase();
    firestore.collection('community')
        .doc(argument['id'])
        .collection("comment")
        .doc(commentId)
        .collection('reply')
        .add({
           "email" : AuthController.instance.authentication.currentUser!.email,
           "name" : AuthController.instance.userModel.value.name,
           'time' : DateTime.now().toIso8601String(),
           'text' : commentC.text,
           'commentId' : commentId,
           'imageUrl' : imgUrl
    });
    commentCountIncrease();
    commentC.text = "";
    setReply("",false,"");
    imgUrl = "";
  }

  void setReply(String name, bool status,String commentId ){
    isReply.value =  status;
    replyName.value = name;
    this.commentId = commentId;
    update();
  }

  Future pickImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imgUrl = pickedFile.path;
    } else {
      print('이미지 선택 취소');
    }
    update();
  }

  Future uploadImageToFirebase() async {
    try {
      if(imgUrl == "") return;

      final storageReference =  firebase_storage.FirebaseStorage.instance
          .ref()
          .child('community/${argument['id']}/comment/${const Uuid().v4()}');

      await storageReference.putFile(File(imgUrl));
      imgUrl = await storageReference.getDownloadURL();
      print('이미지 업로드 완료: $imgUrl');
      return true;
    } catch (e) {
      print('이미지 업로드 실패: $e');
      return false;
    }
  }

  Future<void> deleteCommunity( ) async {
    LoadingUtils.showLoadingPopup();

    try {
      await deleteFolder('community/${argument['id']}');
      await deleteFolder('community/${argument['id']}/comment');
      await deleteChatDocument();

      // 작업이 완료된 후 일정 시간을 기다린 후 로딩 화면을 닫습니다.
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      // 오류 처리: 로딩 화면 닫기 전에 오류 처리를 할 수 있습니다.
      print('Error: $e');
    } finally {
      // 로딩 화면을 닫습니다.
      LoadingUtils.close();
      Get.back();
    }
  }

  Future<void> deleteChatDocument() async {
    await firestore
        .collection('community')
        .doc(argument['id'])
        .delete();
  }

  Future<void> deleteFolder(String folderPath) async {
    final storage = FirebaseStorage.instance;

    if (folderPath == "") return;
    try{
      final ListResult listResult = await storage.ref(folderPath).list();

      if(listResult.items.isNotEmpty){
        for (final Reference item in listResult.items) {
          await item.delete();
        }
      }
     // await storage.ref(folderPath).delete();
      print('폴더 삭제 성공: $folderPath');
    }catch(e){
      print('폴더 삭제 실패: $e');
    }

  }

  void deleteComment(String commentId,{String replyId = ""}) async {

    if(replyId ==""){
      await firestore
          .collection('community')
          .doc(argument['id'])
          .collection('comment')
          .doc(commentId)
          .delete();
    }
    else{
      await firestore
          .collection('community')
          .doc(argument['id'])
          .collection('comment')
          .doc(commentId)
          .collection("reply")
          .doc(replyId)
          .delete();
    }
    commentCountDecrease();
  }
}