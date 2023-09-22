import 'dart:io';

import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/my/change_profile_controller.dart';
import 'package:dev_studygroup_app/util/Dimensions.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common.dart';

class ChangeProfileView extends GetView<ChangeProfileController>{

  @override
  Widget build(BuildContext context) {

    controller.nameC.text = AuthController.instance.userModel.value.name
        .toString();
    controller.descC.text = AuthController.instance.userModel.value.desc
        .toString();
    controller.profileUrl = AuthController.instance.userModel.value.profileUrl
        .toString();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('프로필 변경'),
        actions: [
          IconButton(
            onPressed: () async{
              await controller.uploadImageToFirebase();
              AuthController.instance.changeProfile(controller.nameC.text,
                  controller.descC.text, controller.profileUrl);
              await AuthController.instance.initUser();
              controller.updateNicknameInUserPosts(AuthController.instance
                  .userModel.value.email.toString(), controller.nameC.text,
                  controller.profileUrl);
              Get.back();
            },
            icon: const Icon(Icons.save),)
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: Colors.grey[300],),
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: globalPadding(
                  child: SizedBox(
                    height: Dimensions.screenHeight,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            controller.pickImage();
                          },
                          child: GetBuilder<ChangeProfileController>(
                            builder: (context) {
                              return Container(
                                    width: 200,height: 200,
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: controller.image != null?
                                      Image.file(controller.image!,
                                        fit: BoxFit
                                            .cover,) :
                                      AuthController.instance.userModel.value.profileUrl
                                          ==""?
                                      Image.asset('${Common.iconImgPath}profile_empty.png',fit: BoxFit.fill,):
                                      Image.network(AuthController.instance.userModel
                                          .value.profileUrl.toString())
                                    )
                                );
                            }
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: controller.nameC,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: '이름',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 20)
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          controller: controller.descC,
                          cursorColor: Colors.black,
                          maxLines: null,
                          decoration: const InputDecoration(
                              labelText: '설명',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20)
                          ),
                        ),
                        const SizedBox(height: 30,),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}