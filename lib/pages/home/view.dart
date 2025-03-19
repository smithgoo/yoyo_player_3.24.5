import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:yoyo_player/tools/headfoot.dart';

import 'index.dart';

class HomePage extends GetView<HomeController> {
  @override
  final controller = Get.put<HomeController>(HomeController());

  HomePage({Key? key}) : super(key: key);

  Widget _buildCenterContentView() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 列
          crossAxisSpacing: 10, // 列间距
          mainAxisSpacing: 10, // 行间距
          childAspectRatio: 9 / 16, // 9:16 比例
        ),
        itemCount: controller.state.videosList.length, // 9 个网格项
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var res = controller.state.videosList[index];
              // print(res.toJson());
              Get.toNamed("/video", arguments: res); // 传递参数
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // 圆角
                    child: Image.network(
                      controller.state.videosList[index].cover ?? "", // 示例图片
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 5), // 间距
                Text(
                  controller.state.videosList[index].title ?? '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("Home")),
          body: SafeArea(
            child: Obx(
              () => EasyRefresh(
                controller: controller.easyRefreshController,
                onRefresh: () async {
                  controller.refreshAction();
                },
                onLoad: () async {
                  controller.loadMoreAction();
                },
                // header: EmptyHeader(
                //   triggerOffset: 70.0, // 触发刷新所需的偏移量
                //   clamping: true, // 是否启用回弹效果
                // ),
                // footer: EmptyFooter(
                //   triggerOffset: 70.0, // 触发加载所需的偏移量
                //   clamping: true, // 是否启用回弹效果
                // ),
                child: _buildCenterContentView(),
              ),
            ),
          ),
        );
      },
    );
  }
}
