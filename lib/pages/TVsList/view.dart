import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoyo_player/network/homePage/homePageModel.dart';

import 'index.dart';

class TvslistPage extends GetView<TvslistController> {
  @override
  final controller = Get.put<TvslistController>(TvslistController());
  TvslistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TvslistController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("tvslist")),
          body: SafeArea(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.totalInfoList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      var res = Videos(
                        address: controller.totalInfoList[index]['url'],
                        title: controller.totalInfoList[index]['name'],
                      );
                      Get.toNamed("/video", arguments: res); // 传递参数
                    },
                    child: ListTile(
                      leading: Text(
                        '111',
                        style: TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        controller.totalInfoList[index]['name'], // 右侧国家名称
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
