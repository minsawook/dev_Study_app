import 'dart:ui';

import 'package:dev_studygroup_app/common/route/page.dart';
import 'package:dev_studygroup_app/controller/BottomNavController.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/chat/chat_main.dart';
import 'package:dev_studygroup_app/controller/community/community_main_controller.dart';
import 'package:dev_studygroup_app/scene/chat/chat_main.dart';
import 'package:dev_studygroup_app/scene/community/community_Main.dart';
import 'package:dev_studygroup_app/scene/profil/profil_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../../component/bottomnavi.dart';
import '../../component/textView.dart';
import '../../controller/search_controller.dart';
import '../team/study_Main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {

  final searchController = Get.put(MySearchController());
  final BottomNavControlller _bottomNavController = Get.put(BottomNavControlller());
  final ChatMainController _chatMainController = Get.put(ChatMainController());
  final CommunityMainController _communityMainController = Get.put(CommunityMainController());
  List<String> title = ['스터디 모집','커뮤니티','채팅','프로필'];
  List<dynamic> pages = [StudyMainView(),CommunityMain(),ChatMainView(),ProfilMain()];




  @override
  Widget build(BuildContext context) {
    return  GetBuilder<BottomNavControlller>(builder: (_){
      return  GetBuilder<MySearchController>(
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.white,
              body: RefreshIndicator(
                onRefresh: () async{
                  await AuthController.instance.initUser();
                },
                child: GetBuilder<BottomNavControlller>(builder: (_) {
                  return Column(
                    children: [
                      Divider(color: Colors.grey[300],height: 1,),
                      Expanded(child:  pages[_bottomNavController.selectIndex])
                    ],
                  );

                },),
              ),
              appBar: AppBar(
                toolbarHeight: 40,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                title: !searchController.isSearch.value?
              GetBuilder<BottomNavControlller>
                  (builder: (_) {
                  return Column(
                    children: [
                      Text(
                        title[_bottomNavController.selectIndex],style:  const TextStyle(
                          fontSize: 20
                      ),),
                    ],
                  );
                },)
                    : CupertinoSearchTextField(
                  controller: searchController.searchC,//searchTextController,
                  onChanged: (value) {
                    searchController.search(_bottomNavController.selectIndex,
                        value);
                    searchController.update();
                  },
                  placeholder: '검색',
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child:_bottomNavController.selectIndex !=3? IconButton(
                        onPressed: (){
                          setState(() {
                            searchController.triggerSearch();
                          });
                        },
                        icon: !searchController.isSearch.value? Image.asset
                      ('assets/Icons/icon_search.png',
                          width: 20,height: 20,): TextView(txt: '취소',ignoreClick:
                        true,)):null,
                  )
                ],
              ),
              bottomNavigationBar: BottomNaviArea(),
              floatingActionButton: _bottomNavController.selectIndex <2?
              FloatingActionButton(
              onPressed: () {
                _bottomNavController.selectIndex ==0?
            Get.toNamed(AppPages.MakeStudy) :
                 //   Get.to(MakeCommunityView());
                Get.toNamed(AppPages.MakeCommunity);
          },
          backgroundColor: Common.iconColor,

          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45)
          ),
          child: const Icon(Icons.add,color: Colors.white,size: 45,weight: 23,),

          ):null,
          );
        }
      );
    });


  }
}
