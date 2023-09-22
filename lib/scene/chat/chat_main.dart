
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/common/route/page.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/chat/chat_main.dart';
import 'package:dev_studygroup_app/scene/chat/chat_room_view.dart';
import 'package:dev_studygroup_app/scene/chat/main_chatbox.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatMainView extends GetView<ChatMainController> {
  ChatMainView({super.key});


  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {


    return globalPadding(
      leftPadding: 5,
      rightPadding: 5,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.chatStream(authC.userModel.value.email!),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            var listDocsChats = snapshot.data?.docs;

            if(listDocsChats! == [] || listDocsChats! ==null) {
              return Container();
            } else {
              return ListView.builder(
              itemCount: listDocsChats?.length,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                  stream: controller.studyStream
                    (listDocsChats[index]['studyId']),
                  builder: (context, snapshot2) {
                    if(snapshot2.connectionState == ConnectionState.active){
                      if(snapshot2.data!.exists){
                        var data = snapshot2.data!.data() as Map<String,dynamic>;
                        return MainChatBox(
                          chatName: data!["groupName"],
                          image: data!["studyImg"],
                          pinned: false,
                          time: listDocsChats?[index]['lastTime'],
                          noLeadingCount: listDocsChats?[index]['totalUnread'],
                          currentChat: listDocsChats?[index]['lastChat'],
                          click: () {
                            Get.toNamed(AppPages.ChatRoom,
                                arguments:  {
                                  "chatId": listDocsChats?[index]['chatId'],
                                  "title" : listDocsChats?[index]['connection']
                                      .toString()
                                });
                            //Get.to(ChatRoomView());
                          },);
                      }

                    }
                    return SizedBox();
                  },
                );
              },);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }

}


