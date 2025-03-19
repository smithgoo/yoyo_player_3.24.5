import 'package:get/get.dart';

import 'controller.dart';

class TvBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TvController>(() => TvController());
  }
}
