import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:yoyo_player/network/homePage/homePage.dart';
import 'package:yoyo_player/network/homePage/homePageModel.dart';

import 'index.dart';

class HomeController extends GetxController {
  HomeController();
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  final state = HomeState();

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
    requestInfoList();
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

  refreshAction() {
    easyRefreshController.finishRefresh();
    easyRefreshController.finishLoad();
    easyRefreshController.resetFooter();
    easyRefreshController.resetHeader();
    state.videosList.clear();
    state.currentPage = 1;
    requestInfoList();
  }

  loadMoreAction() {
    easyRefreshController.finishRefresh();
    easyRefreshController.finishLoad();
    easyRefreshController.resetFooter();
    easyRefreshController.resetHeader();
    state.currentPage++;
    requestInfoList();
  }

  requestInfoList() async {
    HomePageInput input = HomePageInput(page: state.currentPage, size: 10);
    HomePageResponse res = await HomePageAPI.homePageListGet(params: input);
    print(input.toJson());
    state.videosList.addAll(res.videos!);
    easyRefreshController.finishRefresh();
    easyRefreshController.finishLoad();
    easyRefreshController.resetFooter();
    easyRefreshController.resetHeader();
    update();
  }
}
