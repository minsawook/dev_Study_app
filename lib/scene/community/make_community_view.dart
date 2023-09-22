import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/community/make_community_controller.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../component/category_picker.dart';
import '../../util/Dimensions.dart';
import 'dart:math' as math;

class MakeCommunityView extends GetView<MakeCommunityController>{
   MakeCommunityView({super.key});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Obx(
            () =>Column(
              children: [
                Divider(color: Colors.grey[300],),
                GestureDetector(
                  onTap: (){
                    Get.bottomSheet(
                      SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:
                                15,),
                                child: Column(
                                  children: [
                                    TextView(
                                      height: 60,
                                      top: 15,
                                      txt: '카테고리',
                                      size: 25,
                                      fontWeight: FontWeight.bold,
                                      align: Alignment.centerLeft,
                                    ),
                                    SizedBox(
                                      height : controller.categoryList.length * 55,
                                      child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: (){
                                                controller.clickCategory(index);
                                                print(controller.selectedIdx);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.transparent,
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextView(
                                                        txt: controller
                                                            .categoryList[index],
                                                        size: 17,
                                                      ),
                                                    ),
                                                    if(controller.selectedIdx ==
                                                        index) SizedBox(
                                                        width: 15,
                                                        child:
                                                        Image.asset(Common.iconImgPath + 'icon_check.png'))
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: controller.categoryList.length),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                      isScrollControlled: true,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 15,
                        vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GetBuilder<MakeCommunityController>(
                            builder: (context) {
                              return TextView(
                                txt: controller.selectedIdx == -1?'카테고리' :
                                controller.categoryList[controller.selectedIdx],
                                fontWeight: FontWeight.bold,
                                size: 17,
                              );
                            }
                          )),
                        Transform.rotate(
                          angle: -90 * math.pi /180,
                          child: Container(
                            width: 25,
                            height: 25,
                            child: Image.asset(Common.iconImgPath + 'icon_back_g'
                                '.png',),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey[300],),
                Expanded(
                  child: globalPadding(
                      topPadding: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.titleC,
                                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                    maxLines: 1,
                                    onChanged: (value) {
                                      controller.update();
                                    },
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: '제목을 입력하세요',
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        )
                                    ),
                                  ),
                                ),
                                GetBuilder<MakeCommunityController>(
                                  builder: (context) {
                                    return TextView(
                                      txt: "${context.titleC.value.text
                                          .length}/20",
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    );
                                  }
                                )
                              ],
                            ),
                            //const SizedBox(height: 5,),
                            TextField(
                              controller: controller.textC,
                              maxLines: null,
                              scrollPhysics: const NeverScrollableScrollPhysics(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                hintText: '내용을 입력하세요',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                  hintStyle: TextStyle(
                                      color: Colors.grey
                                  )
                              ),
                            ),
                            const SizedBox(height: 10,),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if(controller.isEdit.value && controller
                                      .mImgUrlList.isNotEmpty)
                                    SizedBox(
                                      height: 70,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return SizedBox(width: 75,height: 75,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 5,
                                                    right: 5,
                                                    child: Container(
                                                      width: 70,height: 70,
                                                      child: Image.network(controller
                                                          .mImgUrlList[index],fit:
                                                      BoxFit.cover,),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      width: 25,
                                                      child: GestureDetector(
                                                          onTap: (){
                                                            controller.removeImageUrl(index);
                                                          },
                                                          child: Image.asset('${Common.iconImgPath}btn_delete.png')))
                                                ],
                                              ),);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 7,);
                                          },
                                          itemCount: controller.mImgUrlList.length),
                                    ),
                                  if(controller.imageList.isNotEmpty)
                                    SizedBox(
                                      height: 70,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return SizedBox(width: 75,height: 75,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 5,
                                                    right: 5,
                                                    child: Container(
                                                      color: Colors.red,
                                                      width: 70,height: 70,
                                                      child: Image.file(controller.imageList[index],fit:
                                                      BoxFit.cover,),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      width: 25,
                                                      child: GestureDetector(
                                                          onTap: (){
                                                            controller.removeImage(index);
                                                          },
                                                          child: Image.asset('${Common.iconImgPath}btn_delete.png')))
                                                ],
                                              ),);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 7,);
                                          },
                                          itemCount: controller.imageList.length),
                                    ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      )),
                ),
                Divider(color: Colors.grey[300],height: 1),
                GestureDetector(
                  onTap: (){
                    controller.pickImage();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: globalPadding(
                        topPadding: 0,
                        bottonPadding: 0,
                        child: Row(
                          children: [
                            SizedBox(
                                width: 25,
                                child: Image.asset('${Common
                                    .iconImgPath}icon_photo.png')),
                            const SizedBox(width: 10,),
                            TextView(txt: '사진')
                          ],
                        )),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "글 쓰기",
          style:  TextStyle(
              fontSize: 20
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              bool result = controller.checkValidate();
              if(result){
                controller.finalUpLoad();
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
}