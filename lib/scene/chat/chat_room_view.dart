import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/chat/chat_room_controller.dart';
import 'package:dev_studygroup_app/util/Dimensions.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common.dart';

class ChatRoomView extends GetView<ChatRoomController>{

  Map<String, dynamic> arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.readChat(arguments["chatId"].toString());
    // TODO: implement build
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(arguments["title"]),
        actions: [

        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: globalPadding(
          topPadding: 0,
          bottonPadding: 15,
          child: Column(
            children: [
              Divider(color: Colors.grey[300],),
              Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamChat(arguments["chatId"]),
                builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active){
                      var data = snapshot.data!.docs;
                      return ListView.separated(
                        reverse: true,

                        controller: controller.scrollController,
                        itemBuilder: (context, index) {
                          bool showDate = false;
                          bool showProfile = false;
                          if(index == 0 ||
                              (index != data.length-1 &&
                                  data[index+1]['email'] ==
                                      data[index]['email'] &&
                                  data[index-1]['email'] != data[index]['email'] ||
                                  (
                                      data[index-1]['email'] !=
                                          data[index]['email'] &&
                                          data[index+1]['email'] !=
                                              data[index]['email']
                                  )

                              )
                          ) showDate = true;

                          if(index == data.length-1 ||
                              (index != data.length-1 &&
                                  data[index+1]['email'] != data[index]['email'])
                          ) showProfile = true;
                          return MyChatItem(
                            time: data[index]['time'],
                            message: data[index]['message'],
                            isPhoto: data[index]['isPhoto'],
                            send: data[index]['email'],
                            profileUrl: data[index]['profileUrl'],
                            name: data[index]['name'],
                            showProfile: showProfile,
                            showDate: showDate
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox
                          (height: 10,),
                        itemCount: data.length,
                      );
                    }
                    return CircularProgressIndicator();
                },
              )),
              Divider(color: Colors.grey[300],),
              Container(
                //color: Colors.yellow,
                padding: const EdgeInsets.symmetric(vertical: 3),
                //height: 80,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          controller.pickImage(arguments["chatId"]);
                        },
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('${Common.iconImgPath}icon_plus_g.png'),
                        )),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Container(
                          //padding: EdgeInsets.only(top: 15),
                          constraints: const BoxConstraints(
                            maxHeight: 150
                          ),
                          child: TextField(
                            focusNode: controller.focusNode,
                            controller: controller.chatC,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal:
                              25,vertical: 10),
                              fillColor: Colors.grey[200],
                              filled: true,
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  if(controller.chatC.text !="") {
                                    controller.newChat(arguments["chatId"],
                                       controller.chatC.text);
                                  }
                                },
                                child: Container(
                                  height: 25,
                                  child: Image.asset('${Common.iconImgPath}icon_send.png'),
                                ),
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
                        ))
                    //TextField()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyChatItem extends StatelessWidget {
  MyChatItem({
    super.key,
    this.time,
    this.send,
    this.message,
    this.isPhoto,
    this.profileUrl,
    this.name,
    this.showProfile,
    this.showDate});

  bool? isPhoto = false;
  String? message = "";
  String? time ="";
  String? send = "";
  String? name ="";
  String? profileUrl = "";
  bool? showProfile = false;
  bool? showDate = false;
  @override
  Widget build(BuildContext context) {
    return send == AuthController.instance.userModel.value.email?
        //내채팅
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(showDate!)TextView(txt: Util().timeToMessege
          (time!),color: Colors.grey,
          size: 12,),
        const SizedBox(width: 10,),
        Container(
          constraints: BoxConstraints(
            maxWidth:  Dimensions.screenWidth*0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5)
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: !isPhoto!? Text(
              message!,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ) :
            Image.network(message!)
          ),
        )
      ],
    ):
        //다른 사람 챗
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: showProfile!?50 : 0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5)
          ),
          child: showProfile!? profileUrl! ==""? Image.asset('${Common
              .iconImgPath}profile_empty.png'):
          Image.network(profileUrl!):
          Container(),
        ),

        const SizedBox(width: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(showProfile!)TextView(
              txt: name!,
              fontWeight: FontWeight.bold,
              align: Alignment.centerLeft,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: Dimensions.screenWidth*0.5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: !isPhoto!? Text(
                      message!,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ) :
                        Image.network(message!)
                  ),
                ),
                const SizedBox(width: 10,),
                if(showDate!)TextView(txt: Util().timeToMessege(time!)
                  ,color: Colors.grey,size: 12,),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

