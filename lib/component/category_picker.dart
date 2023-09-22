import 'package:dev_studygroup_app/component/textView.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';

class CategoryPicker extends StatefulWidget {
  String title;
  int index;
  int seletedIndex;
  Function(int index)? click;

  CategoryPicker({
    super.key,
    required this.title,
    required this.index,
    required this.seletedIndex,
    this.click});

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: (){
          print(">> tab click : ${widget.index}");
          setState(() {
            if(widget.click != null) {
              widget.click!(widget.index);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 15,right: 15),
          decoration: BoxDecoration(
            color: widget.index == widget.seletedIndex? Common.iconColor :
            Colors.grey[200],
            borderRadius: BorderRadius.circular(45)
          ),
            child: TextView(
              txt: widget.title,
              size: 13,
              align: Alignment.center,
              color: widget.index == widget.seletedIndex? Colors.white : Colors.black,
              ignoreClick: true,
            ),
        ),
      ),
    );
  }
}
