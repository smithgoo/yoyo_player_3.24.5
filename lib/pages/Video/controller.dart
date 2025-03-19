import 'package:get/get.dart';
import 'package:better_player/better_player.dart';
import 'package:yoyo_player/network/homePage/homePage.dart';
import 'package:yoyo_player/network/homePage/homePageModel.dart';
import 'index.dart';

class VideoController extends GetxController {
  late BetterPlayerController betterPlayerController; // 仍然使用 late
  late String videoUrl;
  late Videos videoData;
  final state = VideoState();
  @override
  void onInit() {
    super.onInit();
    // self.linkArr =@[@"https://iptv-org.github.io/iptv/countries/cn.m3u",@"https://iptv-org.github.io/iptv/countries/jp.m3u",@"https://iptv-org.github.io/iptv/countries/kr.m3u",@"https://iptv-org.github.io/iptv/countries/us.m3u",@"https://iptv-org.github.io/iptv/countries/uk.m3u",@"https://iptv-org.github.io/iptv/countries/th.m3u",@""];
    // self.namesArr =@[@"🇨🇳中国",@"🇯🇵日本",@"🇰🇷韩国",@"🇺🇸美国",@"🇬🇧英国",@"🇹🇭泰国",@"☁️热播网剧"];
    videoData = Get.arguments; // 获取传递的数据
    if (videoData != null) {
      state.model = videoData;
      print(videoData.title);
      videoUrl = videoData.address?.split('#')[0] ?? "";
      // videoUrl = 'https://video.bread-tv.com:8091/hls-live24/online/index.m3u8';
      state.items = videoData.address?.split('#');
      initVideoPlayer();
      update();
    }

    // getinfo();
  }

 
  clickItemExchange(idx) {
    betterPlayerController.dispose();
    state.currentIdx = idx;
    videoUrl = videoData.address?.split('#')[idx] ?? "";
    initVideoPlayer();
    update();
  }

  initVideoPlayer() {
    // 确保在初始化之前已经释放播放器

    // 初始化播放器
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
    );

    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: null,
        autoPlay: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePlaybackSpeed: true,
          enableFullscreen: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  closeAndFree() {
    betterPlayerController.dispose();
  }

  @override
  void onClose() {
    // 确保在销毁之前 check `betterPlayerController`
    betterPlayerController.dispose();
    super.onClose();
  }
}
