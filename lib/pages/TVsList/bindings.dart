import 'package:get/get.dart';

import 'controller.dart';

class TvslistBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TvslistController>(() => TvslistController());
  }
}
