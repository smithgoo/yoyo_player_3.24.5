import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoyo_player/network/homePage/homePageModel.dart';

import 'index.dart';

class SearchviewPage extends GetView<SearchviewController> {
  @override
  final controller = Get.put<SearchviewController>(SearchviewController());

  SearchviewPage({Key? key}) : super(key: key);

  Widget _buildCellView(String imageUrl, List<String> texts) {
    return Container(
      height: 200.w,
      margin: EdgeInsets.all(5.w),
      child: Row(
        children: [
          // 左侧 9:16 图片
          Container(
            width: 112.5.w, // 9:16 比例，高度 200.w，所以宽度是 200 * 9 / 16
            height: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.w),
              image: DecorationImage(
                image: NetworkImage(imageUrl), // 你的图片 URL
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 10.w), // 图片和文字之间的间距

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
                  maxLines: index == texts.length - 1 ? 3 : 1, // 最后一个文本最多 3 行
                  overflow: TextOverflow.ellipsis,
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
    return GetBuilder<SearchviewController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // 搜索框
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          decoration: InputDecoration(
                            hintText: "Please input search keyword",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: controller.search,
                        child: Text("Search"),
                      ),
                    ],
                  ),
                ),

                // 历史搜索
                Obx(() => controller.searchHistory.isEmpty
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("History search",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                TextButton(
                                  onPressed: controller.clearHistory,
                                  child: Text("Clean"),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              children: controller.searchHistory
                                  .map((history) => GestureDetector(
                                        onTap: () {
                                          controller.textController.text =
                                              history;
                                          controller.search();
                                        },
                                        child: Chip(label: Text(history)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      )),

                // 搜索结果
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            var res = controller.searchResults[index];
                            print(res.toJson());
                            Get.toNamed("/video", arguments: res); // 传递参数
                          },
                          child: _buildCellView(
                              controller.searchResults[index].cover, [
                            'Title: ${controller.searchResults[index].title}',
                            "Area:  ${controller.searchResults[index].videoArea}",
                            "Year:  ${controller.searchResults[index].videoReleaseTime}",
                            "Content: ${controller.searchResults[index].content}",
                          ]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
