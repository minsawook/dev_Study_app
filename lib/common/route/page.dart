import 'package:dev_studygroup_app/common/binding/chat/chat_main.dart';
import 'package:dev_studygroup_app/common/binding/community/community_info_binding.dart';
import 'package:dev_studygroup_app/common/binding/community/make_communnity_binding.dart';
import 'package:dev_studygroup_app/common/binding/my/change_profile_binding.dart';
import 'package:dev_studygroup_app/scene/chat/chat_main.dart';
import 'package:dev_studygroup_app/scene/chat/chat_room_view.dart';
import 'package:dev_studygroup_app/scene/community/community_info_view.dart';
import 'package:dev_studygroup_app/scene/community/make_community_view.dart';
import 'package:dev_studygroup_app/scene/login/login.dart';
import 'package:dev_studygroup_app/scene/profil/change_profile_view.dart';
import 'package:dev_studygroup_app/scene/team/makeStudy.dart';
import 'package:dev_studygroup_app/scene/team/studyInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../scene/login/bindings.dart';
import '../../scene/splash/splash.dart';
import '../binding/chat/chat_room_biniding.dart';
import '../binding/study/make_study_binding.dart';
import 'names.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static const ChangeProfile = AppRoutes.ChangeProfile;
  static const ChatRoom = '/chatRoom';
  static const MakeStudy = '/makeStudy';
  static const ChatMain = '/chatMain';
  static const MakeCommunity = '/makeCommunity';
  static const CommunityInfo = '/communityInfo';
  //static final RouteObserver<Route> observer = RouteObservers();
  static List<GetPage> routes = [
    GetPage(
        name: AppRoutes.INITIAL,
        page: () => Splash(),
        //binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const Login(),
      //binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.ChangeProfile,
      page: () => ChangeProfileView(),
      binding: ChangeProfileBinding(),
    ),

    GetPage(
      name: ChatRoom,
      page: () => ChatRoomView(),
      binding: ChatRoomBinding(),
    ),

    GetPage(
      name: MakeStudy,
      page: () => MakeStudyView(),
      binding: MakeStudyBinding(),
    ),

    GetPage(
      name: MakeStudy,
      page: () => StudyInfo(model: null),
      binding: MakeStudyBinding(),
    ),

    GetPage(
      name: ChatMain,
      page: () => ChatMainView(),
      binding: ChatMainBinding(),
    ),

    GetPage(
      name: MakeCommunity,
      page: () => MakeCommunityView(),
      binding: MakeCommunityBinding(),
    ),

    GetPage(
      name: CommunityInfo,
      page: () => CommunityInfoView(),
      binding: CommunityInfoBinding(),
    ),

  ];
}