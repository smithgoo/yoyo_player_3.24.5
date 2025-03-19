import 'package:yoyo_player/tools/http.dart';
import 'package:yoyo_player/tools/loginModel.dart';

class LoginAPI {
  ///手机号登录
  static Future<LoginModel> phoneLogin({
    // LoginRequestEntity? params,
    bool cacheDisk = false,
  }) async {
    var response = await HttpUtil().post(
      '/v1/login',
      // data: params?.toJson(),
    );
    return LoginModel.fromJson(response);
  }
}
