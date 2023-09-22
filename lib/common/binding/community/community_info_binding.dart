import 'package:dev_studygroup_app/controller/community/community_info_controller.dart';
import 'package:get/get.dart';

class CommunityInfoBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CommunityInfoController>(() => CommunityInfoController());
  }

}