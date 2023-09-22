import 'package:get/get.dart';

class BottomNavControlller extends GetxController{
  int _selectIndex = 0;
  int get selectIndex => _selectIndex;

  void changeIndex(int index){
    _selectIndex = index;
    update();
    print('bottom index : $_selectIndex');
  }
  }