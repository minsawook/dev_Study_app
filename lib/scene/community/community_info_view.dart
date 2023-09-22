

import 'dart:io';

import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/community/community_info_controller.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../common/common.dart';
import '../../common/route/page.dart';

class CommunityInfoView extends GetView<CommunityInfoController>{
  CommunityInfoView({super.key});

  Color greyColor = Colors.grey;
  var docData;
  @override
  Widget build(BuildContext context) {
    //controller.viewCountIncrease();
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: controller.communityStream(),
                  builder: (context,snapshot) {
                    docData = snapshot.data?.data();

                    if(snapshot.connectionState == ConnectionState.active){

                      if(docData ==null){
                        return Container();
                      }
                      return  Column(
                        children: [

                          //헤더
                          Divider(color: Colors.grey[300],height: 1),
                          globalPadding(
                              bottonPadding: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(horizontal: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    child:  Text(
                                      Common.categoryList[docData!['category']],
                                      style: const TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextView(
                                    txt: docData!['title'],
                                    fontWeight: FontWeight.bold,
                                    size: 20,),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      TextView(
                                        txt: docData!['name'],),
                                      const SizedBox(width: 5,),
                                      TextView(
                                          txt: Util().timeToCommunity(docData!['time']),
                                          size: 13,
                                          color: greyColor),
                                      Expanded(child: Container()),
                                      Icon(Icons.remove_red_eye_outlined,color: greyColor,size:
                                      20,),
                                      const SizedBox(width: 3,),
                                      TextView(txt: docData!['viewCount'].toString(),
                                        color: greyColor,
                                        size: 13,),
                                      const SizedBox(width: 8,),
                                      Icon(Icons.mode_comment_outlined,color: greyColor,size: 20,),
                                      const SizedBox(width: 3,),
                                      TextView(txt: docData?['commentCount'].toString(),
                                        color: greyColor,
                                        size: 13,)
                                    ],
                                  )
                                ],
                              )),
                          Divider(color: Colors.grey[300],height: 1),

                          //본문
                          globalPadding(
                              child: Column(
                                children: [
                                  TextView(
                                      txt: docData!['text'],
                                      size: 18),
                                  const SizedBox(height: 20,),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: docData!['photoList'].length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        width: double.infinity,
                                        child: Image.network
                                          (docData!['photoList'][index],fit: BoxFit
                                            .fill,),
                                      );
                                    },
                                  )
                                ],
                              )),
                          const SizedBox(height: 20,),

                          //댓글
                          Divider(color: Colors.grey[300],height: 1),
                          const SizedBox(height: 20,),
                          globalPadding(
                              child: StreamBuilder(
                                stream: controller.commentStream(),
                                builder: (context,snapshot2) {

                                  if(snapshot2.connectionState == ConnectionState.active){
                                    var commentDocList = snapshot2.data?.docs;
                                    return Column(
                                      children: [
                                        TextView(txt: '댓글 ${docData?['commentCount']}개',
                                          fontWeight: FontWeight.bold,
                                          size: 15,),
                                        ListView.builder(
                                          itemCount: commentDocList?.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return comment
                                              (commentDocList?[index],context);
                                          },
                                        )
                                      ],
                                    );
                                  }

                                  return const Center(child:
                                      CircularProgressIndicator(),);
                                }
                              ))
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                ),
              ),
            ),

            //댓글작성란
            Divider(color: Colors.grey[300],height: 1),
            GetBuilder<CommunityInfoController>(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            controller.pickImage();
                          },
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: Image.asset('${Common.iconImgPath}icon_photo.png'),
                          )),
                      const SizedBox(width: 10,),
                      if(controller.imgUrl != "")SizedBox(
                        width: 40,
                        height: 60,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Image.file(File(controller.imgUrl),fit:BoxFit.cover)),
                            Positioned(
                                right: 0,
                                height: 20,
                                child: GestureDetector(
                                    onTap: (){
                                      controller.imgUrl = "";
                                      controller.update();
                                    },
                                    child: Image.asset('${Common.iconImgPath}btn_delete.png')))
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                            constraints: const BoxConstraints(
                                minHeight: 10,
                                //maxHeight: 500
                            ),
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              autofocus: true,

                              onKey: (value) {
                                if (value.data.logicalKey.keyLabel == "Backspace"
                                && controller.isReply.value
                                &&  controller.commentC.selection
                                        .baseOffset==0){
                                  controller.setReply("", false,"");
                                }
                              },
                              child: TextField(
                                controller: controller.commentC,
                                maxLines: null,
                                focusNode: controller.focusNode,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal:
                                  25,vertical: 10),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  prefix: Obx(
                                    () => Text(
                                      controller.replyName.value,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      if(controller.commentC.text =="" &&
                                          controller.imgUrl =="") return;

                                      controller.isReply.value && controller
                                          .replyName.value.isNotEmpty?
                                      controller.writeReply():
                                      controller.writeComment();
                                    },
                                    child: Image.asset('${Common
                                        .iconImgPath}icon_send.png',width: 40),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(45),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(45),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ))
                      //TextField()
                    ],
                  ),
                );
              }
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
          "글 쓰기",
          style:  TextStyle(
              fontSize: 20
          ),
        ),
        actions:  [
          if(Get.arguments['writer'] == AuthController.instance.userModel.value.email)
            GestureDetector(
              onTap: (){
                Get.toNamed(AppPages.MakeCommunity,arguments: {
                  "isEdit" : true,
                  "data" : docData,
                  'id' : Get.arguments['id']
                });
              },
              child: const Padding(padding: EdgeInsets.only(right: 15),child:
              Icon(Icons.edit,))),
          GestureDetector(
              onTap: (){
                controller.deleteCommunity();
              },
              child: const Padding(padding: EdgeInsets.only(right: 15),child:
              Icon(Icons.delete,))),
        ],
      ),
    );
  }

  Widget comment(var data, BuildContext context, {bool isMessage = true, int
  index=0, String commentId = ""}){
    return GestureDetector(
      onLongPress: (){
        controller.setReply( isMessage? data['name'] :
        commentId, true, data.id.toString());
        FocusScope.of(context).requestFocus(controller.focusNode);
      },
      child: Row(
        children: [
          if(!isMessage) Container(
            width: 25*(index+1),
          constraints: const BoxConstraints(
            maxWidth: 75,
          )),
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(top: isMessage?10:0),
              child: StreamBuilder(
                    stream: controller.replyStream(data.id),
                     builder: (context, snapshot) {

                      if(snapshot.connectionState == ConnectionState.active) {
                        var replyDocList = snapshot.data?.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextView(
                                  txt: data['name'],
                                  fontWeight: FontWeight.bold,
                                  size: 17,),
                                const SizedBox(width: 5,),
                                if(data['email'] == AuthController.instance.userModel.value
                                    .email)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                        color: Common.iconColor,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: const Text(
                                      '작성자',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                if(data['email'] == AuthController.instance.userModel.value
                                    .email)const SizedBox(width: 5,),
                                TextView(txt: Util().getTimeDifference(data['time']),size: 12,color: Colors.grey,),
                                Expanded(child: Container()),
                                if(data['email'] == AuthController.instance.userModel.value
                                    .email)
                                  PopupMenuButton<int>(
                                    surfaceTintColor: Colors.white,
                                    onSelected: (item) {
                                      switch(item){
                                        case 0: isMessage? controller
                                            .deleteComment(data.id.toString()) :
                                        controller
                                            .deleteComment( commentId,replyId: data.id
                                            .toString());
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
                                      const PopupMenuItem<int>(
                                        value: 0,
                                        child: Text('삭제'),
                                      ),
                                      // const PopupMenuItem<SampleItem>(
                                      //   value: SampleItem.itemTwo,
                                      //   child: Text('Item 2'),
                                      // ),
                                      // const PopupMenuItem<SampleItem>(
                                      //   value: SampleItem.itemThree,
                                      //   child: Text('Item 3'),
                                      // ),
                                    ],
                                  ),
                                //   GestureDetector(
                                //   onTap: (){
                                //
                                //   },
                                //   child: Image.asset('${Common.iconImgPath}icon_menu_dot.png',height: 15,),
                                // )
                              ],
                            ),
                            const SizedBox(height: 5,),
                            TextView(
                              txt: data['text'],
                              size: 15,),
                            if(data['imageUrl'] != "")Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 150,maxHeight: 200,
                                ),
                                child: Image.network(data['imageUrl'],fit:
                                BoxFit.cover,),
                              ),
                            ),
                            const SizedBox(height: 7,),
                            if(replyDocList!.isNotEmpty && isMessage)Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Image.asset("${Common.iconImgPath}icon_comment.png",width: 20,)),
                                    TextView(txt: '답글 ${replyDocList.length}개',
                                      color: Colors.grey,
                                      left: 5,)
                                  ],
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: replyDocList!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return comment(replyDocList![index],context,
                                        isMessage: false, index: index,
                                        commentId: data.id);
                                  },
                                )
                              ],
                            )
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator(),);
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}

