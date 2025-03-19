import 'package:get/get.dart';
import 'package:yoyo_player/network/homePage/homePage.dart';

import 'index.dart';

class TvController extends GetxController {
  TvController();
  final List<String> linkArr = [
    "https://iptv-org.github.io/iptv/countries/cn.m3u",
    "https://iptv-org.github.io/iptv/countries/jp.m3u",
    "https://iptv-org.github.io/iptv/countries/kr.m3u",
    "https://iptv-org.github.io/iptv/countries/us.m3u",
    "https://iptv-org.github.io/iptv/countries/uk.m3u",
    "https://iptv-org.github.io/iptv/countries/th.m3u",
  ].obs;
  List<String> namesArr = [
    "🇨🇳中国",
    "🇯🇵日本",
    "🇰🇷韩国",
    "🇺🇸美国",
    "🇬🇧英国",
    "🇹🇭泰国",
    "☁️热播网剧"
  ].obs;
  final state = TvState();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
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
