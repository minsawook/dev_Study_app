import 'package:dev_studygroup_app/controller/my/change_profile_controller.dart';
import 'package:dev_studygroup_app/scene/login/controller.dart';
import 'package:get/get.dart';

class ChangeProfileBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ChangeProfileController>(() => ChangeProfileController());
  }
}