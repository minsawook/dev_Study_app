import 'package:dev_studygroup_app/controller/chat/chat_main.dart';
import 'package:get/get.dart';

import '../../../controller/chat/chat_room_controller.dart';

class ChatMainBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ChatMainController>(() => ChatMainController());
  }
}