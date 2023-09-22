import 'package:dev_studygroup_app/controller/BottomNavController.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/controller/my/change_profile_controller.dart';
import 'package:get/get.dart';

import 'study/make_study_controller.dart';

class InitalViewModel implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<BottomNavControlller>(() => BottomNavControlller());
    //Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ChangeProfileController>(() => ChangeProfileController());
    Get.lazyPut<MakeStudyController>(() => MakeStudyController());
  }
}