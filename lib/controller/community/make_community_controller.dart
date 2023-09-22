import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/component/loading.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class MakeCommunityController extends GetxController{
  late TextEditingController titleC;
  late TextEditingController textC;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<dynamic> imgUrlList= [].obs;
  RxList<dynamic> mImgUrlList= [].obs;
  List<String> deleteImgUrlList= [];
  final picker = ImagePicker();
  RxList<dynamic> imageList = [].obs;

  RxBool isEdit = false.obs;

  List<String> categoryList = ['자유게시판','유머','궁금해요','취업/면접','멘토링','직무'];
  int selectedIdx = -1;

  String uuid = const Uuid().v4();
  String id = "";
  @override
  void onInit() {
    // TODO: implement onInit
    titleC = TextEditingController();
    textC = TextEditingController();

    if(Get.arguments ==null) return;
    print(Get.arguments);
    isEdit.value = Get.arguments['isEdit'];

    if(isEdit.value) {
      titleC.text = Get.arguments['data']['title'];
      textC.text = Get.arguments['data']['text'];
      selectedIdx = Get.arguments['data']['category'];
      imgUrlList.value = List.from(Get.arguments['data']['photoList']) ;
      mImgUrlList.value = List.from(Get.arguments['data']['photoList']) ;
      id= Get.arguments["id"];
    }

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleC.dispose();
    textC.dispose();
    super.dispose();
  }


  Future pickImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageList.add(File(pickedFile.path));
    } else {
      print('이미지 선택 취소');
    }
    update();
  }

  Future uploadImageToFirebase() async {
    if(imageList.isEmpty) return;

    String ref = isEdit.value? id : uuid;
    try {
      for(var element in imageList){
        final storageReference =  firebase_storage.FirebaseStorage.instance
            .ref()
            .child('community/$ref/${const Uuid().v4()}');

        await storageReference.putFile(element);
        String url = await storageReference.getDownloadURL();
        imgUrlList.add(url);
      }
      print('이미지 업로드 완료: $imgUrlList');
    } catch (e) {
      print('이미지 업로드 실패: $e');
    }
  }

  void removeImage(int index){
    imageList.removeAt(index);
  }

  void removeImageUrl(int index){
    deleteImgUrlList.add(imgUrlList[index]);
    mImgUrlList.removeAt(index);
    imgUrlList.removeAt(index);
  }

  void clickCategory(int index){
    selectedIdx = index;
    Get.back();
    update();
  }

  bool checkValidate(){
    if(selectedIdx ==-1){
      Get.snackbar(
        '카테고리 선택오류',
        '카테고리를 선택해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }
    else if(titleC.text.isEmpty){
      Get.snackbar(
        '오류',
        '제목을 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }
    else if(textC.text.isEmpty){
      Get.snackbar(
        '오류',
        '내용을 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }
    else{
      return true;
    }
  }


  uploadDb() async {
    CollectionReference community = firestore.collection
      ('community');

    if(isEdit.value){
      await community.doc(id).update({
        "title" : titleC.text,
        "email" : AuthController.instance.authentication.currentUser!.email,
        "name" : AuthController.instance.userModel.value.name,
        "text" : textC.text,
        "photoList" : imgUrlList,
        "category" : selectedIdx,
      });
    }
    else{
      await community.doc(uuid).set({
        "title" : titleC.text,
        "email" : AuthController.instance.authentication.currentUser!.email,
        "name" : AuthController.instance.userModel.value.name,
        "time" : DateTime.now().toIso8601String(),
        "text" : textC.text,
        "photoList" : imgUrlList,
        "viewCount" : 0,
        "category" : selectedIdx,//categoryList[selectedIdx],
        "commentCount" : 0
      });
    }

  }

  void finalUpLoad() async {
    LoadingUtils.showLoadingPopup();
    try{
      await uploadImageToFirebase();

    }catch(e){
      print('커뮤니티 수정/생성 실패 : $e');
    }finally{
      await uploadDb();
      for(var url in deleteImgUrlList){
        await AuthController.instance.deleteImageUrl(url);
      }
      print('object');
      LoadingUtils.close();
      Get.back();
      // Get.snackbar(
      //   '완료',
      //   '게시글 작성 완료.',
      //   snackPosition: SnackPosition.BOTTOM,
      //   forwardAnimationCurve: Curves.elasticInOut,
      //   reverseAnimationCurve: Curves.easeOut,
      // );
    }


   //

  }
}