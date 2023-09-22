import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/search_controller.dart';
import 'package:dev_studygroup_app/scene/team/studyInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common.dart';
import '../../component/textView.dart';
import '../../model/study_group_model.dart';
import '../../util/util.dart';

class StudyMainView extends GetView<AuthController> {
   StudyMainView({super.key});

  final MySearchController _searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return globalPadding(
        child: Obx(
          () {
            var data = _searchController.isSearch.value?
            _searchController.queryAwal.value:
            controller.studyGroupModelList.value;
           return ListView.separated(
                itemBuilder: (context, index) {
                  num max= 0;
                  num current = 0;
                  for(var positionList in data[index]['positionList']){
                    max += positionList['max'];
                    current += positionList['current'];
                  }
                  return GestureDetector(
                    onTap: (){
                      Get.to(StudyInfo(model: data[index],));
                      //Get.toNamed(StudyInfo(model: data[index]));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                      height: 80,
                      color: Common.basicColor,
                      child: Row(
                        children: [
                          Container(
                            width: 50,height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: data[index]['studyImg'] == ""?
                              Image.asset('${Common.iconImgPath}profile_empty.png'):
                              Image.network(data[index]['studyImg']),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextView(
                                  txt: data
                                  [index]['groupName'],
                                  fontWeight: FontWeight.bold,
                                  isEllipsis: true,
                                  maxLen: 1,),
                                const SizedBox(height: 10,),
                                TextView(
                                  txt: data[index]['desc'],
                                  size: 12,
                                  isEllipsis: true,
                                  maxLen: 1,)
                              ],
                            ),
                          ),
                          const SizedBox(width: 5,),
                          TextView(txt: '${current.toString()
                          }/${max
                            .toString()}',
                            size: 15,)
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10,);
                },
                itemCount: data.length);
          },
        )
    );
  }
}

