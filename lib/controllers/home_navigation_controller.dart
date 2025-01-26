import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  int tabIndex = 1;

  void changeTab(int i) {
    tabIndex = i;
    update();
  }
}
