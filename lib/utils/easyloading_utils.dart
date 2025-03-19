import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

///@Description     xxxx 

class EasyLoadingUtils {
// 显示动画
  static Future<void> showLoading({toast}) async {
    EasyLoading.show(status: toast ?? "");
  }

// 隐藏动画
  static Future<void> hideLoading() async {
    EasyLoading.dismiss();
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}