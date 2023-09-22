import 'package:dev_studygroup_app/controller/study/study_info_controller.dart';
import 'package:get/get.dart';

class StudyInfoBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<StudyInfoController>(() => StudyInfoController());
  }

}