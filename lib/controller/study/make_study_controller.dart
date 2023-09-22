
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/model/chats_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import '../auth_controller.dart';

class MakeStudyController extends GetxController{
  late TextEditingController nameC;
  late TextEditingController descC;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? profileUrl= '';
  final picker = ImagePicker();
  File? image;
  RxList position =  [].obs;
  RxBool isProject = false.obs;
  List<TextEditingController> positionName = [];
  String uuid = const Uuid().v4();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameC = TextEditingController();
    descC = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameC.dispose();
    descC.dispose();
    profileUrl = null;
    position.clear();
    isProject = false.obs;
  }

  void checkProject(bool value){
    isProject.value = value;
    position.clear();
  }

  void removePositon(int index){
    position.removeAt(index);
  }

  void addPositon(){
    if(!isProject.value && position.value.length >=1) return;
    positionName.add(TextEditingController(text: "포지션입력"));
    position.add({"positionName":"포지션 입력", 'max': 1,"current":0});
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
          .child('study_profile_img/${uuid}');
      await storageReference.putFile(File(image!.path));
      profileUrl = await storageReference.getDownloadURL();

      print('이미지 업로드 완료: $profileUrl');
    } catch (e) {
      print('이미지 업로드 실패: $e');
    }
  }
  bool checkValidate(){
    if(nameC.text.isEmpty || descC.text.isEmpty || position.value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> saveStudyGroup() async {
    CollectionReference studyGroup = firestore.collection
      ('studyGroup');

    String date = DateTime.now().toIso8601String();

    /*챗방 doc 만들면서 유저목록 추가*/
    CollectionReference chats =firestore.collection('chats');

    final newChatDoc = await chats.add(
        {
          "connection" : [
            AuthController.instance.userModel.value.email,
          ]
        });


    //방장에게 챗목록 추가
    CollectionReference users = firestore.collection("users");


    final docChat = await users.doc(AuthController.instance.userModel.value
        .email).collection("chats").doc(newChatDoc.id).set({
      "connection": nameC.text,
      "chatId": newChatDoc.id,
      "lastTime": date,
      "totalUnread" : 0,
      "lastChat" : "",
      "isRead" : false,
      "studyId" : uuid
    }) ;

    AuthController.instance.userModel.refresh();

    /*스터디 추가*/
    await uploadImageToFirebase();

    await studyGroup.doc(uuid).set({
      "groupName": nameC.text,
      "desc" : descC.text,
      "groupLeader" :  AuthController.instance.authentication.currentUser!
          .email.toString(),
      "member" : [AuthController.instance.authentication.currentUser!.email
          .toString()],
      "studyImg" : profileUrl,
      "positionList" : position,
      "createdAt": date,
      "requestJoin": [],
      "chatId" : newChatDoc.id,
      "studyId" : uuid
    });

    addNewConnection();
    Get.back();
  }

  void addNewConnection() async{

  }

  }

