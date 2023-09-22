import 'package:auto_size_text/auto_size_text.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/study/make_study_controller.dart';
import 'package:dev_studygroup_app/controller/study/study_info_controller.dart';
import 'package:dev_studygroup_app/util/Dimensions.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';

class StudyManagementView extends GetView<StudyInfoController>{
   StudyManagementView({super.key});


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: SafeArea(
          child: globalPadding(
            topPadding: 0,
            child: GetBuilder<StudyInfoController>(
              builder: (_) {
                return SizedBox(
                  width: Dimensions.screenWidth,
                  height: Dimensions.screenHeight,
                  child: Column(
                    children: [
                      Divider(color: Colors.grey[300],),
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                                return Container(
                                    height: 60,
                                    color: Common.basicColor,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,height: 60,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child:
                                              controller.model['requestJoin'][index]['profileUrl']==""?
                                              Image.asset('${Common.iconImgPath}profile_empty.png',fit: BoxFit.fill,):
                                              Image.network
                                                (controller.model['requestJoin'][index]['profileUrl'])
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: AutoSizeText(controller.model['requestJoin'][index]['name'],
                                              style:  const TextStyle(fontSize: 14,),
                                              minFontSize: 5,
                                              maxLines: 2,
                                              maxFontSize: 20,
                                            ),
                                          ),
                                        ),
                                        // TextView(
                                        //     left: 10,
                                        //     txt:
                                        //     controller.model['requestJoin'][index]['name'] ),
                                        const SizedBox(width: 15,),
                                        Expanded(child:
                                        AutoSizeText(controller.model['requestJoin'][index]['positionName'],
                                          style:  const TextStyle(fontSize: 14,),
                                          minFontSize: 5,
                                          maxLines: 1,
                                          maxFontSize: 20,
                                        ),
                                        // Text
                                        //   (controller.model['requestJoin'][index]['positionName'])
                                        ),
                                        const SizedBox(width: 10,),

                                        //수락
                                        GestureDetector(
                                          onTap: (){
                                              controller.addStudyMember
                                                (controller
                                                  .model['requestJoin']?[index]['email'],
                                                  controller.model['requestJoin']?[index]['positionName']);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric
                                              (horizontal: 12),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only
                                                (topLeft: Radius.circular(5), bottomLeft:
                                              Radius.circular(5)),
                                              color: Colors.blueAccent
                                            ),
                                            child: TextView(
                                              txt: '수락',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            controller.cancelJoin(controller.model['requestJoin'][index]['email']);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric
                                              (horizontal: 12),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only
                                                  (topRight: Radius.circular(5),
                                                    bottomRight:
                                                Radius.circular(5)),
                                                color: Colors.redAccent
                                            ),
                                            child: TextView(
                                              txt: '거절',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 8,);
                            },
                            itemCount: _.model['requestJoin'] == null? 0 :
                            _.model['requestJoin'].length),
                      )
                    ],
                  ),
                );
              }
            ),
          )),
      appBar: AppBar(
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "가입 신청",
          style:  TextStyle(
              fontSize: 20
          ),
        ),

      ),
    );
  }
}