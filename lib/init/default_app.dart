import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_player/init/global_binding.dart';
import 'package:yoyo_player/network/dio_util.dart';
import 'package:yoyo_player/resource/constant.dart';
import 'package:yoyo_player/router/router_map.dart';
import 'package:yoyo_player/utils/cache_util.dart';
import 'package:yoyo_player/utils/provider.dart';
import 'package:yoyo_player/utils/toast_utils.dart';

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Note: permissions aren't requested here just to demonstrate that can be
/// done later
final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
  notificationCategories: darwinNotificationCategories,
);
final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
  DarwinNotificationCategory(
    darwinNotificationCategoryText,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.text(
        'text_1',
        'Action 1',
        buttonTitle: 'Send',
        placeholder: 'Placeholder',
      ),
    ],
  ),
  DarwinNotificationCategory(
    darwinNotificationCategoryPlain,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.plain('id_1', 'Action 1'),
      DarwinNotificationAction.plain(
        'id_2',
        'Action 2 (destructive)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
      DarwinNotificationAction.plain(
        navigationActionId,
        'Action 3 (foreground)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'id_4',
        'Action 4 (auth required)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.authenticationRequired,
        },
      ),
    ],
    options: <DarwinNotificationCategoryOption>{
      DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    },
  )
];

///@description   默认App的启动
class DefaultApp {
  //运行app
  static void run() {
    WidgetsFlutterBinding.ensureInitialized();

    initFirst().then((value) {
      runApp(Store.init(ToastUtils.init(MyApp())));
      // WidgetsBinding.instance!.addPostFrameCallback((_) {
      //   print('addd');
      //   requestAppTrackingPermission();
      // });
    });

    //Loading 设置
    // configLoading();
  }

  /// 必须要优先初始化的内容
  static Future<void> initFirst() async {
    await CacheUtil.init();
    // await LocaleUtils.init();

    /// 打印init
    // Log.init();
    initDio();

    if (Platform.isIOS) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings(
            '@mipmap/ic_launcher',
          ),
          iOS: initializationSettingsDarwin),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print(
                'NotificationResponseType.selectedNotification:被点击了${notificationResponse.payload}');
            if (notificationResponse.payload != null) {
              // 点击通知时获取消息信息
              Map<String, dynamic> message =
                  jsonDecode(notificationResponse.payload!);
              print('Notification payload: $message');
              // 在这里处理通知点击事件，您可以导航到相关的页面或执行其他操作
              // Get.offAll(MainHomePage(), arguments: {'pageIndex': 1, 'tabIndex': message['notifyType'] == 1 ? 0 : 1});
            }
            break;
          case NotificationResponseType.selectedNotificationAction:
            print('NotificationResponseType.selectedNotificationAction:被点击了');
            break;
        }
      },
    );
  }

  static void initDio() {
    /// 统一添加身份验证请求头
    // DioUtil.dio.interceptors.add(AuthInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      // DioUtil.dio.interceptors.add(LoggingInterceptor());
    }
  }
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int i = 1;
  String _deviceId = '';

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('androidInfo.id: ${androidInfo.id.toString()}');
      setState(() {
        _deviceId = androidInfo.id.toString();
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iosInfo.identifierForVendor: ${iosInfo.identifierForVendor}');
      setState(() {
        _deviceId = iosInfo.identifierForVendor.toString();
      });
    }

    if (CacheUtil.isLogined()) {}
  }

  @override
  Widget build(BuildContext context) {
    final easyload = EasyLoading.init();

    return Consumer2<AppTheme, LocaleModel>(
        builder: (context, appTheme, localeModel, _) {
      return GetMaterialApp(
        initialBinding: InitBinding(),
        title: '乐玩',
        theme: ThemeData(
          brightness: appTheme.brightness,
          primarySwatch: appTheme.themeColor,
        ),
        getPages: RouterMap.getPages,
        initialRoute: '/',
        defaultTransition: Transition.rightToLeft,
        locale: localeModel.getLocale(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        localeResolutionCallback:
            (Locale? _locale, Iterable<Locale> supportedLocales) {
          if (localeModel.getLocale() != null) {
            //如果已经选定语言，则不跟随系统
            return localeModel.getLocale();
          } else {
            return Locale('zh', 'CN');
          }
        },
        navigatorKey: globalNavigatorKey,
        builder: (context, widget) {
          /// 初始化screen_util
          ScreenUtil.init(context, designSize: const Size(375, 812));
          ScreenUtil().setSp(28);
          widget = easyload(context, widget);
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                hideKeyboard(context);
              },
              child: widget,
            ),
          );
        },
        //MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget!)
      );
    });
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    print('杀死app断开连接');
    super.dispose();
  }

  Future<void> showNotification(message) async {
    final androidDetail = AndroidNotificationDetails(
      'Notification',
      '乐玩',
      channelDescription: 'color background channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.blue,
      colorized: true,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );

    final iOSDetail = const DarwinNotificationDetails(
      sound: 'slow_spring_board.aiff',
    );
    final platformDetail =
        NotificationDetails(android: androidDetail, iOS: iOSDetail);
    final notificationTitle = message['title'];
    final notificationBody = message['message'];
    await flutterLocalNotificationsPlugin.show(
        0, notificationTitle, notificationBody, platformDetail,
        payload: jsonEncode(message));
  }
}
