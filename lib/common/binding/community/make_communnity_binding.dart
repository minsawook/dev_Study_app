import 'package:dev_studygroup_app/controller/community/make_community_controller.dart';
import 'package:get/get.dart';

class MakeCommunityBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MakeCommunityController>(() => MakeCommunityController());
    // TODO: implement dependencies
  }
}