import 'package:yoyo_player/network/homePage/homeSearchModel.dart';
import 'package:yoyo_player/tools/http.dart';

import './homePageModel.dart';

class HomePageAPI {
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
}
