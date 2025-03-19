import 'package:get/get.dart';
import 'package:yoyo_player/network/homePage/homePage.dart';

import 'index.dart';

class TvslistController extends GetxController {
  TvslistController();

  final state = TvslistState();
  var totalInfoList = [].obs;
  // tap
  void handleTap(int index) {
    Get.snackbar(
      "标题",
      "消息",
    );
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    var info = Get.arguments; // 获取传递的数据
    getinfo(info['link']);
  }

  getinfo(url) async {
    try {
      List<Map<String, String>> channels =
          await HomePageAPI.fetchM3UChannels(url);
      for (var channel in channels) {
        print("名称: ${channel['name']}");
        print("Logo: ${channel['icon']}");
        print("播放地址: ${channel['url']}");
        print("------------------------");
        totalInfoList.add(channel);
      }
      update();
    } catch (e) {
      print("解析 M3U 失败: $e");
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
