import 'package:dev_studygroup_app/common/route/page.dart';
import 'package:dev_studygroup_app/component/category_picker.dart';
import 'package:dev_studygroup_app/component/community_listBox.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/community/community_main_controller.dart';
import 'package:dev_studygroup_app/util/Dimensions.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common.dart';
import '../../controller/search_controller.dart';

class CommunityMain extends StatefulWidget {
  const CommunityMain({super.key});

  @override
  State<CommunityMain> createState() => _CommunityMainState();
}

class _CommunityMainState extends State<CommunityMain> {


  final communityC = Get.find<CommunityMainController>();
  final MySearchController _searchController = Get.find();
  final List<String> _categoryList = ['전체','자유게시판','유머','궁금해요','취업/면접','멘토링','직무'];
  int _selectedIdx = 0;


  @override
  Widget build(BuildContext context) {

    // 화면의 전체 높이
    double screenHeight = MediaQuery.of(context).size.height;

    // 앱 바의 높이
    double appBarHeight = AppBar().preferredSize.height;

    // 하단 네비게이션 바의 높이
    double bottomNavigationHeight = kBottomNavigationBarHeight;

    // 앱 바와 하단 네비게이션 바의 높이를 제외한 남은 공간의 크기
    double remainingHeight = screenHeight - 40 - 70;

    return globalPadding(

        child: GetBuilder<MySearchController>(
          builder: (context) {
            return StreamBuilder(
              stream: communityC.communityStream(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.active) {
                  var listDocsCommunity = snapshot.data!.docs;
                  var listDoc = [];

                  var bestList = List<dynamic>.from(listDocsCommunity);

                  bestList.sort((a, b) {
                    int viewsA = a.data()['viewCount'];
                    int viewsB = b.data()['viewCount'];
                    return viewsB.compareTo(viewsA); // Compare in descending order
                  });

                  bestList = bestList.take(3).toList();

                  listDocsCommunity.forEach((element) {
                    if( _selectedIdx ==0 || element['category'] ==
                        _selectedIdx-1) listDoc.add(element);
                  });

                  var data = [];
                  if(_searchController.isSearch.value){
                    if(_searchController.searchC.text ==""){
                      data = List<dynamic>.from(listDoc);
                    }

                    else{
                      for(var d in listDoc){
                        if(d['text'].toString().contains(_searchController.searchC
                            .text ) ||
                            d['title'].toString().contains(_searchController
                                .searchC.text)){
                          data.add(d);
                        }
                      }
                    }
                  }
                  else{
                    data = List<dynamic>.from(listDoc);
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        expandedHeight:  remainingHeight/2-30,
                        floating: false,
                        pinned: false,
                        // toolbarHeight: 0,
                        flexibleSpace: SizedBox(
                            child: Column(
                              children: [
                                TextView(txt: 'Best Top 3',
                                  fontWeight: FontWeight.bold,
                                  size: 18,),
                                const SizedBox(height: 10,),
                                Expanded(
                                  child: ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        int commentCount = 0;

                                        return CommunityListBox(
                                            title: bestList[index]['title'],
                                            comment: bestList[index]['commentCount'],
                                            uploadTime: Util().timeToCommunity(bestList[index]['time']),
                                            viewCount: bestList[index]['viewCount'],
                                            writer: bestList[index]['name'],
                                            click: (){
                                              Get.toNamed(AppPages.CommunityInfo
                                                  ,arguments: {
                                                    'id':bestList[index].id,
                                                    'writer' : bestList[index]['email']
                                                  });
                                            },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10,);
                                      },
                                      itemCount: bestList.length),
                                )
                              ],
                            )),
                      ),

                      SliverAppBar(
                        scrolledUnderElevation: 0,
                        pinned: true,
                        floating: false,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        bottom: const PreferredSize(
                          preferredSize: Size.fromHeight(-10), child: SizedBox(),
                        ),
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(top: 7,bottom: 7),
                          child: SizedBox(
                            width: Dimensions.screenWidth,
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categoryList.length,
                              itemBuilder: (context, index) {
                                return CategoryPicker(
                                  title: _categoryList[index],
                                  index: index,
                                  seletedIndex: _selectedIdx,
                                  click: (index){
                                    setState(() {
                                      _selectedIdx = index;
                                    });
                                  },
                                );
                              },),
                          ),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: data.length,
                                (context, index) {

                              return Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  CommunityListBox(
                                      title: data[index]['title'],
                                      comment: data[index]['commentCount'],
                                      uploadTime: Util().timeToCommunity(data[index]['time']),
                                      viewCount: data[index]['viewCount'],
                                      writer:  data[index]['name'],
                                  click: (){
                                    Get.toNamed(AppPages.CommunityInfo
                                        ,arguments: {'id':data[index].id,
                                                    'writer' : data[index]['email']});
                                  },),
                                ],
                              );
                            },
                          ))
                    ],
                  );
                }
                else{
                  return const Center(child: CircularProgressIndicator());
                }

              }
            );
          }
        ));
  }
}
