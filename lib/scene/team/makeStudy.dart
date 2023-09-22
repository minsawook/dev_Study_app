import 'package:dev_studygroup_app/color_schemes.g.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/study/make_study_controller.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import '../../common/common.dart';

class MakeStudyView extends GetView<MakeStudyController>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: globalPadding(
                bottonPadding: 0,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(txt: "스터디 이름",
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),

                      const SizedBox(height: 10,),
                      TextField(
                        controller: controller.nameC,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: '터치해서 입력하세요',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Common.basicColor
                        ),
                      ),
                      const SizedBox(height: 30,),
                      TextView(txt: "스터디 사진",
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        child: GetBuilder<MakeStudyController>(
                          builder: (context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: controller.image != null?
                              Image.file(controller.image!,
                                fit: BoxFit
                                    .cover,) :
                              IconButton(onPressed: (){
                                controller.pickImage();
                              },
                                  icon: const Icon(Icons.add,size: 100,)),
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 30,),
                      TextView(txt: "스터디 설명",
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10,),

                      Container(
                        height: 180,
                        child: TextField(
                          controller: controller.descC,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                              hintText: '터치해서 입력하세요',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Common.basicColor
                          ),
                        ),
                      ),

                      //프로젝트
                      Row(
                        children: [
                          Obx(
                            () =>  Checkbox(value: controller.isProject.value,
                                activeColor: Common.iconColor,
                                onChanged: (value){
                                  controller.checkProject(value!);
                                }),
                          ),
                          TextView(txt: "프로젝트",
                            size: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Obx(
                        () => Container(
                          height: controller.position.value.length*65,
                          child: ListView.builder(
                            itemCount: controller.position.value.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                      height: 55,
                                      width: double.maxFinite,
                                      color: Common.basicColor,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                controller.removePositon(index);
                                              }, icon:  Icon(Icons
                                              .remove_circle,color: Common.iconColor,)),
                                          Expanded(
                                            child: TextField(
                                              controller: controller
                                                  .positionName[index],
                                              maxLines: null,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(15)
                                              ],
                                              onChanged: (value){
                                                controller.position
                                                    .value[index]['positionName'] = value;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none
                                              ),
                                            ),
                                  //             child: Text
                                  //           (controller.position
                                  //             .value[index]['positionName']
                                  // .toString())
                                          ),
                                          _numChange(index),
                                          const SizedBox(width: 10,)
                                        ],
                                      )

                                  ),
                                  const SizedBox(height: 10,)
                                ],
                              );
                            },),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(child:
            TextButton(
              child: TextView(txt: "+팀원 추가",
                fontWeight: FontWeight.bold,
              ),
              onPressed: () {
                controller.addPositon();
              },
            )
            )
          ],
        ),
      ),


      appBar: AppBar(
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "스터디 생성",
          style:  TextStyle(
              fontSize: 20
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              bool result =  controller.checkValidate();
              if(result){
                controller.saveStudyGroup().then((value) {
                  AuthController.instance.getStudyGroupModel();
                  Get.snackbar(
                    '생성완료',
                    '스터디가 생성 되었습니다.',
                    snackPosition: SnackPosition.BOTTOM,
                    forwardAnimationCurve: Curves.elasticInOut,
                    reverseAnimationCurve: Curves.easeOut,
                  );
                });
              }
              else{
                Get.snackbar(
                  '생성실패',
                  '팀원을 추가해 주세요.',
                  snackPosition: SnackPosition.BOTTOM,
                  forwardAnimationCurve: Curves.elasticInOut,
                  reverseAnimationCurve: Curves.easeOut,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: const Text('완료',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),),
            ),
          )
        ],
      ),
    );
  }

  Widget _numChange(int index){
    return Obx(
      () => Row(
        children: [
          Container(
            height: 35,
            width: 35,
            color: Colors.white,
            child: IconButton(
              icon:  Icon(Icons.remove,size: 20,color: Common.iconColor,),
              onPressed: (){
                if(controller.position.value[index]["max"]<=1) return;
                --controller.position.value[index]["max"];
                controller.position.refresh();
              },
            ),
          ),
          Container(
              height: 35,
              width: 35,
              color: Colors.white,
              child: Center(
                child: Text(
                    controller.position.value[index]["max"].toString(),
                    style: const TextStyle(
                        color: Colors.black
                    ),
                  ),
              )
          ),
          Container(
            height: 35,
            width: 35,
            color: Colors.white,
            child: IconButton(
              icon:  Icon(Icons.add,size: 20,color: Common.iconColor),
              onPressed: (){
                ++controller.position.value[index]["max"];
                controller.position.refresh();
              },
            ),
          ),
        ],
      ),
    );
  }
}
