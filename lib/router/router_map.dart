import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoyo_player/pages/Application/index.dart';
import 'package:yoyo_player/pages/Application/view.dart';
import 'package:yoyo_player/pages/TVsList/bindings.dart';
import 'package:yoyo_player/pages/TVsList/view.dart';
import 'package:yoyo_player/pages/Video/bindings.dart';
import 'package:yoyo_player/pages/Video/view.dart';
import 'package:yoyo_player/pages/test/bindings.dart';
import 'package:yoyo_player/pages/test/view.dart';
import 'package:yoyo_player/pages/home/bindings.dart';
import 'package:yoyo_player/pages/home/view.dart';

class RouterMap {
  static List<GetPage> getPages = [
    GetPage(
      name: '/',
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
    ),
    GetPage(
      name: '/video',
      page: () => VideoPage(),
      binding: VideoBinding(),
    ),
    GetPage(
      name: '/tvList',
      page: () => TvslistPage(),
      binding: TvslistBinding(),
    ),
  ];

  /// 页面切换动画
  static Widget getTransitions(
      BuildContext context,
      Animation<double> animation1,
      Animation<double> animation2,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
              //1.0为右进右出，-1.0为左进左出
              begin: Offset(1.0, 0.0),
              end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }
}
