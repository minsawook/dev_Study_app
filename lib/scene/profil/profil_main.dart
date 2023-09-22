import 'package:auto_size_text/auto_size_text.dart';
import 'package:dev_studygroup_app/common/common.dart';
import 'package:dev_studygroup_app/common/route/names.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/my/change_profile_controller.dart';
import 'package:dev_studygroup_app/scene/profil/change_profile_view.dart';
import 'package:dev_studygroup_app/scene/profil/profil_button.dart';
import 'package:dev_studygroup_app/util/Dimensions.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/login.dart';

class ProfilMain extends StatefulWidget {

  const ProfilMain({super.key});

  @override
  State<ProfilMain> createState() => _ProfilMainState();
}

class _ProfilMainState extends State<ProfilMain> {

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: globalPadding(
        child: Column(
          children: [
            Row(
              children: [
                Obx(
                  () => Container(
                    width: 70,height: 60,
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: (AuthController.instance.userModel.value
                          .profileUrl
                          =="" && AuthController.instance.userModel.value.profileUrl
                          =="")?
                      Image.asset('${Common.iconImgPath}profile_empty.png',fit:
                      BoxFit.cover,):
                      Image.network(AuthController.instance.userModel
                          .value.profileUrl.toString(),fit:
                      BoxFit.cover)
                    )
                  ),
                ),
                Expanded(child: Obx(
                  () =>  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AuthController.instance.userModel.value.name.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      AutoSizeText(AuthController.instance.authentication
                          .currentUser!.email.toString(),
                        style:  const TextStyle(fontSize: 14,),
                        minFontSize: 5,
                        maxLines: 1,
                        maxFontSize: 20,
                      )
                    ],
                  ),
                )),
                FilledButton.tonal(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Common.basicColor)
                    ),
                    onPressed: () {
                      Get.toNamed(AppRoutes.ChangeProfile);
                    }, child: TextView( txt: '편집',size: 10,)),
                SizedBox(width: 10,),
                FilledButton.tonal(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Common.basicColor)
                    ),
                    onPressed: () {
                      AuthController.instance.logout();
                      Get.offAll(Login());
                    }, child: TextView( txt: '로그아웃',size: 10,))
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: Dimensions.screenWidth,
              padding: const EdgeInsets.only(top: 5,bottom: 5, right: 10,left: 10),
              decoration: BoxDecoration(
                color: Common.basicColor,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Obx(
                () =>  Text(
                  '${AuthController.instance.userModel.value.desc}',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              )
            ),
            const SizedBox(height: 12,),
            Divider(color: Colors.grey[300],),
            const SizedBox(height: 8,),
            TextView(txt: '채팅',fontWeight: FontWeight.bold,size: 20,),
            ProfilButton(title: '백업',
            imageLink: Common.iconImgPath + 'icon_backup.png',
            click: (){

            },),
            ProfilButton(title: '복구',
              imageLink: Common.iconImgPath + 'icon_chat.png',
              click: (){

              },),
            const SizedBox(height: 10,),

            TextView(txt: '보안',fontWeight: FontWeight.bold,size: 20,),
            ProfilButton(title: '비밀번호 번경',
              imageLink: Common.iconImgPath + 'icon_pw.png',
              click: (){

              },),
            const SizedBox(height: 10,),

            TextView(txt: '설정',fontWeight: FontWeight.bold,size: 20,),
            ProfilButton(title: '알림 설정',
              imageLink: Common.iconImgPath + 'icon_alarm.png',
              click: (){

              },),
            const SizedBox(height: 10,),

            TextView(txt: '고객센터',fontWeight: FontWeight.bold,size: 20,),
            ProfilButton(
              imageLink: Common.iconImgPath + 'icon_search.png',
              title: '알림 설정',),
            ProfilButton(
              imageLink: Common.iconImgPath + 'icon_search.png',
              title: '자주 묻는 질문',),

          ],
        )
      ),
    );
  }
}
