import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoyo_player/pages/SearchView/view.dart';

import 'package:yoyo_player/pages/home/view.dart';

import 'index.dart';

class ApplicationPage extends GetView<ApplicationController> {
  final controller = Get.put<ApplicationController>(ApplicationController());

  // 内容页
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
      children: <Widget>[
        HomePage(),
        SearchviewPage(),
        // TvsviewPage(),
      ],
    );
  }

  // 自定义底部导航栏
  Widget _buildCustomBottomNavigationBar() {
    return Obx(() => Container(
          height: 60.h, // 设置底部导航栏的高度
          decoration: BoxDecoration(
            color: Colors.white, // 背景颜色
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // 均匀分布
            children: controller.bottomTabs.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = controller.state.page == index;

              return InkWell(
                onTap: () => controller.handleNavBarTap(index), // 点击切换页面
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      [Icons.home, Icons.search][index], // 使用 item 中的图标
                      size: 24.sp,
                      color: isSelected ? Colors.red : Colors.grey, // 选中状态颜色
                    ),
                    SizedBox(height: 4.h), // 图标和文字的间距
                    Text(
                      ['Home', 'search'][index], // 使用 item 中的标签
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isSelected ? Colors.red : Colors.grey, // 选中状态颜色
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }
}
