import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_player/utils/cache_util.dart';

//状态管理
class Store {
  Store._internal();

  //全局初始化
  static init(Widget child) {
    //多个Provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AppTheme(getDefaultTheme(), getDefaultBrightness())),
        ChangeNotifierProvider.value(value: LocaleModel(CacheUtil.getLocale())),
        ChangeNotifierProvider.value(
            value: UserProfile(CacheUtil.getToken(), CacheUtil.getUserName())),
        ChangeNotifierProvider.value(value: AppStatus(TAB_HOME_INDEX)),
        ChangeNotifierProvider.value(value: WebSocketProvider())
      ],
      child: child,
    );
  }

  //获取值 of(context)  这个会引起页面的整体刷新，如果全局是页面级别的
  static T value<T>(BuildContext context, {bool listen = false}) {
    return Provider.of<T>(context, listen: listen);
  }

  //获取值 of(context)  这个会引起页面的整体刷新，如果全局是页面级别的
  static T of<T>(BuildContext context, {bool listen = true}) {
    return Provider.of<T>(context, listen: listen);
  }

  // 不会引起页面的刷新，只刷新了 Consumer 的部分，极大地缩小你的控件刷新范围
  static Consumer connect<T>({builder, child}) {
    return Consumer<T>(builder: builder, child: child);
  }
}

MaterialColor getDefaultTheme() {
  return AppTheme.materialColors[CacheUtil.getThemeIndex() ?? 0];
}

Brightness getDefaultBrightness() {
  return CacheUtil.getBrightness() ?? Brightness.light;
}

///主题
class AppTheme with ChangeNotifier {
  static final List<MaterialColor> materialColors = [
    Colors.blue,
    Colors.lightBlue,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.grey,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.lime
  ];

  MaterialColor _themeColor;

  Brightness _brightness;

  AppTheme(this._themeColor, this._brightness);

  void setColor(MaterialColor color) {
    _themeColor = color;
    notifyListeners();
  }

  void changeColor(int index) {
    _themeColor = materialColors[index];
    CacheUtil.saveThemeIndex(index);
    notifyListeners();
  }

  void setBrightness(bool isLight) {
    notifyListeners();
  }

  void changeBrightness(bool isDark) {
    _brightness = isDark ? Brightness.dark : Brightness.light;
    CacheUtil.saveBrightness(isDark);
    notifyListeners();
  }

  get themeColor => _themeColor;

  get brightness => _brightness;
}

///跟随系统
const String LOCALE_FOLLOW_SYSTEM = "auto";

///语言
class LocaleModel with ChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale? getLocale() {
    if (_locale == LOCALE_FOLLOW_SYSTEM) return null;
    var t = _locale.split("_");
    return Locale(t[0], t[1]);
  }

  String _locale = LOCALE_FOLLOW_SYSTEM;

  LocaleModel(this._locale);

  // 获取当前Locale的字符串表示
  String get locale => _locale;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (_locale != locale) {
      _locale = locale;
      // I18n.locale = getLocale()!;
      CacheUtil.saveLocale(_locale);
      notifyListeners();
    }
  }
}

///用户账户信息
class UserProfile with ChangeNotifier {
  String _token;
  String _userName;

  UserProfile(this._token, this._userName);

  String get token => _token;
  String get userName => _userName;

  set token(String token) {
    _token = token;
    CacheUtil.saveToken(token);
    notifyListeners();
  }

  set userName(String userName) {
    _userName = userName;
    CacheUtil.saveUserName(userName);
    notifyListeners();
  }
}

///首页
const int TAB_HOME_INDEX = 0;

///活动
// const int TAB_ACTIVITY_INDEX = 1;

///消息
const int TAB_MESSAGE_INDEX = 1;

///工作台
const int TAB_WORKBENCH_INDEX = 2;

///我的
const int TAB_PROFILE_INDEX = 3;

///应用状态
class AppStatus with ChangeNotifier {
  //首页tab的索引
  int _tabIndex;

  AppStatus(this._tabIndex);

  int get tabIndex => _tabIndex;

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}

class WebSocketProvider extends ChangeNotifier {
  bool _showBadge = false;

  bool get showBadge => _showBadge;

  void updateBadgeCount(bool show) {
    _showBadge = show;
    notifyListeners();
  }
}
