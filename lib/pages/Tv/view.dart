import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class TvPage extends GetView<TvController> {
  @override
  final controller = Get.put<TvController>(TvController());
  TvPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TvController>(
      builder: (_) {
        return Scaffold(
          body: Obx(
            () => ListView.builder(
              itemCount: controller.linkArr.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.namesArr[index]),
                  trailing: Icon(Icons.link),
                  onTap: () {
                    print("点击了: ${controller.linkArr[index]}");
                    // 你可以在这里添加跳转或播放逻辑
                    var res = controller.linkArr[index];
                    Get.toNamed("/tvList", arguments: {'link': res}); // 传递参数
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
