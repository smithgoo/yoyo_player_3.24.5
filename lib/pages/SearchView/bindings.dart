import 'package:get/get.dart';

import 'controller.dart';

class SearchviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchviewController>(() => SearchviewController());
  }
}
