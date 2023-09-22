import 'package:auto_size_text/auto_size_text.dart';
import 'package:dev_studygroup_app/common/common.dart';
import 'package:dev_studygroup_app/common/enum.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/study/make_study_controller.dart';
import 'package:dev_studygroup_app/controller/study/study_info_controller.dart';
import 'package:dev_studygroup_app/model/study_group_model.dart';
import 'package:dev_studygroup_app/scene/team/study_management_view.dart';
import 'package:dev_studygroup_app/util/Dimensions.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/textView.dart';

class StudyInfo extends StatefulWidget {
   StudyInfo({super.key,
   required this.model});
  late var model;
  @override
  State<StudyInfo> createState() => _StudyInfoState();
}

class _StudyInfoState extends State<StudyInfo> with TickerProviderStateMixin{

  int _selectedRadio = -1;
  late var model;
  num max= 0;
  num current = 0;

  final StudyInfoController _studyInfoController = Get.put(StudyInfoController());
  final _authController = AuthController.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _studyInfoController.initModel(widget.model);

    model = _studyInfoController.model;

    for(var positionList in model['positionList']){
      max += positionList['max'];
      current += positionList['current'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: GetBuilder<StudyInfoController>(
          builder: (context) {
            return Container(
              height: Dimensions.screenHeight,
              child: Column(
                children: [
                  Expanded(child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: Stack(
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              color: Colors.grey,
                            child: model['studyImg']==""?
                            Image.asset('${Common.iconImgPath}profile_empty.png',
                              fit: BoxFit.cover,):
                            Image.network(model['studyImg'],fit: BoxFit.cover),),
                            if(AuthController.instance.authentication.currentUser
                                !.email == model['groupLeader'])Positioned(
                              right: 10,
                              child: FilledButton.tonal(onPressed: (){
                                _studyInfoController.removeGroup();
                              },
                                  child: Text('그룹해체')),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 15,
                                right: 15,
                                child: Container(
                                  height: 60,
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,height: 60,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: model['studyImg']==""?
                                            Image.asset('${Common.iconImgPath}profile_empty.png',fit: BoxFit.fill,):
                                            Image.network(model['studyImg'])
                                          ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(right: 3),
                                          alignment: Alignment.bottomLeft,
                                          child: AutoSizeText(
                                              model['groupName'],
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextView(txt: '${_studyInfoController
                                          .current}/${_studyInfoController
                                          .max}',
                                        align: Alignment.bottomLeft,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: globalPadding(
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                Container(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  width: double.maxFinite,
                                  color: Common.basicColor,
                                  constraints: const BoxConstraints(
                                      minHeight: 50
                                  ),
                                  child: TextView(
                                    txt: model['desc'],
                                  ),
                                ),
                                TextView(
                                  txt: '모집',
                                  align: Alignment.centerLeft,
                                  size: 20,
                                  top: 5,),
                                Expanded(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return Container(
                                            height: 55,
                                            color: Common.basicColor,
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: index,
                                                  groupValue: _selectedRadio,
                                                  onChanged: (value) {
                                                    if (model['positionList'][index]['max'] ==
                                                        model['positionList'][index]['current']) {
                                                      setState(() {
                                                        print('Max and current are equal or null.');
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _selectedRadio = value!;
                                                      });
                                                    }
                                                  },
                                                  activeColor: Common.iconColor,
                                                ),
                                                Expanded(child: Text
                                                  (model['positionList'][index]['positionName'])),
                                                const SizedBox(width: 10,),
                                                TextView(txt: '${model['positionLis'
                                                    't'][index]['current']}/${model
                                                ['positionList'][index]['max']}',
                                                  right: 15,)
                                              ],
                                            )
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10,);
                                      },
                                      itemCount: model['positionList'].length),
                                )
                              ],
                            ),
                          ))
                    ],
                  )),

                  Divider(height: 1,color: Colors.grey[300],),
                  Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
                    child: GestureDetector(
                      onTap: () async {

                        if(AuthController.instance.authentication.currentUser
                        !.email == model['groupLeader']){
                          Get.to(StudyManagementView());
                        }
                        else {
                          print(_studyInfoController.alreadyApplied() );
                          //탈퇴
                          if(_studyInfoController.alreadyApplied() == 'join'){

                          }
                          //가입취소
                          else if(_studyInfoController.alreadyApplied() == 'applied'){
                           await _studyInfoController.cancelJoin
                             (AuthController.instance.authentication
                               .currentUser!.email.toString());
                          }
                          //가입 신청
                          else{
                            List<Map<String,dynamic>> data=[];

                            if(model['requestJoin'] != null){
                              for(var requestJoin in model['requestJoin']){
                                data.add(requestJoin);
                              }
                            }

                            data.add({
                              'name' : _authController.userModel.value.name,
                              'desc' : _authController.userModel.value.desc,
                              'email' : _authController.userModel.value.email,
                              'profileUrl' : _authController.userModel.value.profileUrl,
                              'positionName': model['positionList'][_selectedRadio]['positionName']
                            });

                            await _studyInfoController.joinStudyGroup(model['groupName'],
                                data);
                            Get.snackbar(
                              '스터디 지원',
                              '지원이 완료되었습니다.',
                              snackPosition: SnackPosition.BOTTOM,
                              forwardAnimationCurve: Curves.elasticInOut,
                              reverseAnimationCurve: Curves.easeOut,
                            );
                          }
                          AuthController.instance.getStudyGroupModel();
                        }
                        setState(() {

                        });
                      },
                      child: Container(height: 40,width: double.infinity,
                        decoration: BoxDecoration(
                          color: Common.iconColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextView(
                          txt: AuthController.instance.authentication.currentUser
                        !.email == model['groupLeader']? "지원현황":
                          _studyInfoController.alreadyApplied() == 'join'?
                          '가입됨'://'탈퇴''하기':
                          _studyInfoController.alreadyApplied() == 'applied'?
                          '지원 취소''하기': '지원하기',
                          ignoreClick: true,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          size: 20,
                          align: Alignment.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      )
    );
  }
}
