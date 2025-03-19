import 'homePageModel.dart';

class HomeSearchInput {
  String? keyword;

  HomeSearchInput({this.keyword});

  HomeSearchInput.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    return data;
  }
}

class HomeSearchResponse {
  int? page;
  int? size;
  int? total;
  List<Videos>? data;

  HomeSearchResponse({this.page, this.size, this.total, this.data});

  HomeSearchResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
    total = json['total'];
    if (json['data'] != null) {
      data = <Videos>[];
      json['data'].forEach((v) {
        data!.add(new Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['size'] = this.size;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
