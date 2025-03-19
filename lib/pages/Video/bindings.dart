import 'package:get/get.dart';

import 'controller.dart';

class VideoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoController>(() => VideoController());
  }
}
