import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

void showImageViewer(List<String> images, int index) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async {
        return true; // 允许弹框被关闭
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity, // 填充宽度
            height: double.infinity, // 填充高度
            color: Colors.black, // 设置背景色
            child: PhotoViewGallery.builder(
              itemCount: images.length,
              builder: (context, i) => PhotoViewGalleryPageOptions(
                // imageProvider: NetworkImage(images[i]),
                imageProvider: AssetImage(images[i]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: Colors.black, // 后景色
              ),
              pageController: PageController(initialPage: index),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white), // 关闭按钮的图标
              onPressed: () {
                Get.back(); // 关闭弹框
              },
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: true, // 点击背景关闭对话框
  );
}

