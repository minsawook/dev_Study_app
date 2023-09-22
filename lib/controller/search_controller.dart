import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MySearchController extends GetxController{
  late TextEditingController searchC;

  var queryAwal = [].obs;
  RxBool isSearch = false.obs;


  void search(int index,String data){
    switch(index){
      case 0:
        seachStudyGroup(data);
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }
  void seachStudyGroup(String data,){

    if(searchC.text.isEmpty){
      queryAwal.value = AuthController.instance.studyGroupModelList;
      return;
    }
    queryAwal.value = [];
    for(var model in AuthController.instance.studyGroupModelList){
      if(model['groupName'].toString().contains(data) ||
          model['desc'].toString().contains(data)){
        queryAwal.value.add(model);
      }
    }
  }

  void triggerSearch({bool? value}){
    if(value == null) {
      isSearch.value = !isSearch.value;
    }
    else{
      isSearch.value = value;
    }
    if(!isSearch.value ){
      queryAwal.value = [];
      searchC.text="";
    }
    else{
      queryAwal.value = AuthController.instance.studyGroupModelList;
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    searchC = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    searchC.dispose();
  }
}