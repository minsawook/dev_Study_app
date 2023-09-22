import 'dart:async';

import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';

class MainChatBox extends StatefulWidget {
  String? image;
  String chatName;
  String? currentChat;
  int? noLeadingCount;
  bool? pinned;
  String? time;
  Function()? click;

  MainChatBox({
    super.key,
    required this.chatName,
    this.currentChat,
    this.image,
    this.noLeadingCount,
    required this.pinned,
    this.time,
    this.click});

  @override
  State<MainChatBox> createState() => _MainChatBoxState();
}

class _MainChatBoxState extends State<MainChatBox> {

  late Timer timer;
  String agoTime= '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget != null){
      agoTime =  Util().getTimeDifference(widget.time!);
      //print(agoTime);
    }
    timer = Timer.periodic(const Duration(seconds: 45), (timer) {
      setState(() {
        if(widget != null){
          agoTime =  Util().getTimeDifference(widget.time!);
          //print(agoTime);
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer in dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    int noLeadingCount = widget.noLeadingCount?? 0;
    String currentChat = widget.currentChat?? '';
    return  Padding(
      padding: const EdgeInsets.only(top: 3,bottom: 3,left: 10,right: 10),
      child: GestureDetector(
        onTap: (){
          if(widget.click != null) widget.click!.call();
        },
        child: Container(
          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
          height: 80,
          decoration: BoxDecoration(
            color: Common.basicColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            children: [
              Container(
                width: 70,height: 60,
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.image == ""?Image.asset
                  ('assets/Icons/profile_empty.png')
                    : Image.network(widget.image.toString()),
              ),

              Expanded(
                  child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(widget.chatName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      if(widget.pinned!)const Icon(Icons.pin_drop),
                      Expanded(child: Container()),
                      Text(agoTime,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                        ),),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextView(txt: currentChat,
                          ignoreClick: true,
                          maxLen: 1,
                          isEllipsis: true,
                          size: 20,
                          align: Alignment.topLeft,
                          bottom: 8,
                        ),
                      ),
                      //Expanded(child: Container()),
                      if(noLeadingCount >0)Container(
                        height: 25,
                        padding: const EdgeInsets.only(top: 2,bottom: 2,left: 4,
                            right: 4),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(45)
                        ),
                        child: TextView(
                          txt: noLeadingCount >99? '99+' : noLeadingCount
                              .toString(),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              )),

            ],
          ),
        ),
      ),
    );
  }
}
