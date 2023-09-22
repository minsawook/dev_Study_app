import 'package:dev_studygroup_app/component/textView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/BottomNavController.dart';
import '../controller/search_controller.dart';

class BottomNaviArea extends StatefulWidget {
  const BottomNaviArea({super.key});

  @override
  State<BottomNaviArea> createState() => _BottomNaviAreaState();
}

class _BottomNaviAreaState extends State<BottomNaviArea> {
  final BottomNavControlller _bottomNavControlller = Get.find();
  final MySearchController _searchController = Get.find();
  int _seletedIndex =0;
  void _onItemTap(int index){
    setState(() {
      _seletedIndex = index;
      _bottomNavControlller.changeIndex(_seletedIndex);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        onTap: (int index){
          _onItemTap(index);
          _searchController.triggerSearch(value: false);
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _seletedIndex,
        items: [
          BottomNavigationBarItem(
            label: '홈',
            icon: Image.asset('assets/Icons/icon_home.png', width: 30, height: 30,),
            activeIcon: Image.asset('assets/Icons/icon_home_on.png',width: 30,height: 30,)
          ),
          BottomNavigationBarItem(
              label: '커뮤니티',
              icon: Image.asset('assets/Icons/icon_community.png', width: 30, height: 30,),
              activeIcon: Image.asset('assets/Icons/icon_community_on.png',width:
              30,height: 30,)
          ),
          BottomNavigationBarItem(
              label: '채팅',
              icon: Image.asset('assets/Icons/icon_chat.png', width: 30, height: 30,),
              activeIcon: Image.asset('assets/Icons/icon_chat_on.png',width:
              30,height: 30,)
          ),
          BottomNavigationBarItem(
              label: '프로필',
              icon: Image.asset('assets/Icons/icon_profile.png', width: 30, height: 30,),
              activeIcon: Image.asset('assets/Icons/icon_profile_on.png',width:
              30,height: 30,)
          ),
        ],
      ),
    );
  }
}
