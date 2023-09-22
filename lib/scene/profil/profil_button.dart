import 'package:dev_studygroup_app/component/textView.dart';
import 'package:flutter/material.dart';

class ProfilButton extends StatelessWidget {

  String title;
  String? imageLink;
  Function()? click;

  ProfilButton({
    super.key,
    this.click,
    required this.title,
    this.imageLink
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(click != null)click!;
      },
      child: Container(height:45,
      child: Row(
        children: [
          imageLink ==null?SizedBox(
              width: 25,
              height: 25,
              child: Image.asset('assets/login/splash.jpg', fit: BoxFit.cover)) :
          SizedBox(
            width: 30,
            height: 30,
                child: Image
                .asset(imageLink!, fit: BoxFit.fill),
              ),
           const SizedBox(width: 15,),
          TextView(
              txt: title,
              size: 18,
              ignoreClick: true,)
        ],
      ),),
    );
  }
}
