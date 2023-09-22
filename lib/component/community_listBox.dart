import 'package:dev_studygroup_app/component/textView.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';

class CommunityListBox extends StatefulWidget {
  String title;
  String writer;
  int viewCount;
  int comment;
  dynamic uploadTime;
  Function click;

   CommunityListBox({
    super.key,
    required this.title,
    required this.comment,
    required this.uploadTime,
    required this.viewCount,
    required this.writer,
    required this.click});

  @override
  State<CommunityListBox> createState() => _CommunityListBoxState();
}

class _CommunityListBoxState extends State<CommunityListBox> {
  Color greyColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.click();
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            color: Common.basicColor,
            borderRadius: BorderRadius.circular(3)
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: TextView(txt: widget.title,
                fontWeight: FontWeight.bold,
                size: 15,),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 100
                      ),
                      child: Text(widget.writer.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                          color: greyColor,
                        ),
                      ),
                    ),
                    TextView(txt:'|'+ widget.uploadTime,
                    color: greyColor,
                    size: 13,),
                    Expanded(child: Container()),
                    Icon(Icons.remove_red_eye_outlined,color: greyColor,size:
                    20,),
                    const SizedBox(width: 3,),
                    TextView(txt: widget.viewCount.toString(),
                    color: greyColor,
                    size: 13,),
                    const SizedBox(width: 8,),
                    Icon(Icons.mode_comment_outlined,color: greyColor,size: 20,),
                    const SizedBox(width: 3,),
                    TextView(txt: widget.comment.toString(),
                      color: greyColor,
                      size: 13,)

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
