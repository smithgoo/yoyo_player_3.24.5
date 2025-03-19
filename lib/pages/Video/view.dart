import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class VideoPage extends GetView<VideoController> {
  const VideoPage({Key? key}) : super(key: key);

  // 主视图

  Widget _buildPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: controller.betterPlayerController),
    );
  }

  Widget _buildTitleView() {
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      child: Text(
        "剧集:",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildGradView() {
    return // 这里添加网格方块
        Container(
      height: 140, // 高度可根据需要调整
      padding: EdgeInsets.all(10.w),
      child: GridView.builder(
        itemCount: controller.state.items.length, // 网格中方块的数量
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // 每行的方块数
          crossAxisSpacing: 10, // 水平间距
          mainAxisSpacing: 10, // 垂直间距
          childAspectRatio: 1, // 方块宽高比例，设置为1表示正方形
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.clickItemExchange(index);
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              color: index == controller.state.currentIdx
                  ? Colors.red
                  : Colors.blue, // 方块的颜色
              child: Center(
                child: Text(
                  '${index + 1}', // 方块中显示的内容
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoView(List<String> texts) {
    return Container(
      margin: EdgeInsets.all(5.w),
      child: Row(
        children: [
          // 右侧 4 行平均分布的文本
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 让 4 行均匀分布
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                texts.length,
                (index) => Text(
                  texts[index],
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  maxLines:
                      index == texts.length - 1 ? null : 1, // 最后一个文本最多 3 行
                  overflow:
                      TextOverflow.visible, // Optional, to allow text overflow
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      builder: (_) {
        return Obx(
          () => Scaffold(
            appBar: AppBar(
              title: Text("${controller.state.model.title}"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  controller.closeAndFree(); // 关闭视频并释放资源
                  Get.back(); // 使用 GetX 返回上一页
                },
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildPlayer()),
                _buildTitleView(),
                _buildGradView(),
                _buildInfoView([
                  'Title: ${controller.state.model.title}',
                  "Area:  ${controller.state.model.videoArea}",
                  "Year:  ${controller.state.model.videoReleaseTime}",
                  "Content: ${controller.state.model.content}",
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
