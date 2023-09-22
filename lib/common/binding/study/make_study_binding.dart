import 'package:dev_studygroup_app/controller/study/make_study_controller.dart';
import 'package:get/get.dart';

class MakeStudyBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<MakeStudyController>(() => MakeStudyController());
  }
}