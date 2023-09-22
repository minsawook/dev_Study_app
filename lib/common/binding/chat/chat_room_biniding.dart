import 'package:get/get.dart';

import '../../../controller/chat/chat_room_controller.dart';

class ChatRoomBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ChatRoomController>(() => ChatRoomController());
  }
}