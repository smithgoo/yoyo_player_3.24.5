import 'package:dio/dio.dart';
import 'package:yoyo_player/network/homePage/homeSearchModel.dart';
import 'package:yoyo_player/tools/http.dart';

import './homePageModel.dart';

class HomePageAPI {
  static get http => null;

  //联盟主页
  static Future<HomePageResponse> homePageListGet({
    HomePageInput? params,
    bool cacheDisk = false,
  }) async {
    try {
      var response = await HttpUtil().get(
        '/getHomeAll',
        queryParameters: params?.toJson(),
        cacheDisk: cacheDisk,
      );
      // print("Response Data: ${response.toString()}");
      return HomePageResponse.fromJson(response);
    } catch (e) {
      print("Error during API call: $e");
      rethrow;
    }
  }

  static Future<HomeSearchResponse> searchListByKeyWords({
    HomeSearchInput? params,
    bool cacheDisk = false,
  }) async {
    try {
      var response = await HttpUtil().post(
        '/searchVideos',
        data: params?.toJson(),
      );
      print("Response Data: ${response.toString()}");
      return HomeSearchResponse.fromJson(response);
    } catch (e) {
      print("Error during API call: $e");
      rethrow;
    }
  }

  // self.linkArr =@[@"https://iptv-org.github.io/iptv/countries/cn.m3u",@"https://iptv-org.github.io/iptv/countries/jp.m3u",@"https://iptv-org.github.io/iptv/countries/kr.m3u",@"https://iptv-org.github.io/iptv/countries/us.m3u",@"https://iptv-org.github.io/iptv/countries/uk.m3u",@"https://iptv-org.github.io/iptv/countries/th.m3u",@""];
  // self.namesArr =@[@"🇨🇳中国",@"🇯🇵日本",@"🇰🇷韩国",@"🇺🇸美国",@"🇬🇧英国",@"🇹🇭泰国",@"☁️热播网剧"];

  static Future<List<Map<String, String>>> fetchM3UChannels(String url) async {
    print('22222');
    try {
      Dio dio = Dio();
      Response response = await dio.get(url);
      print('22222');
      print(response.data.toString());
      if (response.statusCode == 200) {
        return parseM3U(response.data.toString());
      } else {
        throw Exception("获取 M3U 失败，状态码：${response.statusCode}");
      }
    } catch (e) {
      throw Exception("请求 M3U 时发生错误: $e");
    }
  }

  static List<Map<String, String>> parseM3U(String content) {
    List<Map<String, String>> channels = [];
    List<String> lines = content.split("\n");

    String? currentIcon;
    String? currentName;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.startsWith("#EXTINF")) {
        // 解析 tvg-logo 和频道名称
        RegExp regExp = RegExp(r'tvg-logo="([^"]+)"');
        Match? match = regExp.firstMatch(line);
        currentIcon = match != null ? match.group(1) : null;

        List<String> parts = line.split(",");
        if (parts.length > 1) {
          currentName = parts.last;
        }
      } else if (line.startsWith("http") && line.contains(".m3u8")) {
        // 解析 m3u8 地址
        channels.add({
          "name": currentName ?? "未知频道",
          "icon": currentIcon ?? "",
          "url": line
        });
        currentIcon = null;
        currentName = null;
      }
    }
    return channels;
  }
}
