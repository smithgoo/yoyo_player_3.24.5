class HomePageInput {
  int? page;
  int? size;

  HomePageInput({this.page, this.size});

  HomePageInput.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['size'] = this.size;
    return data;
  }
}


class HomePageResponse {
  int? page;
  int? size;
  int? total;
  List<Videos>? videos;

  HomePageResponse({this.page, this.size, this.total, this.videos});

  HomePageResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
    total = json['total'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['size'] = this.size;
    data['total'] = this.total;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  int? iD;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? title;
  String? cover;
  String? content;
  String? address;
  String? otherName;
  String? videoDirector;
  String? videoMaincharacter;
  String? videoType;
  String? videoArea;
  String? videoLanguage;
  String? videoReleaseTime;
  String? videoUpdate;

  Videos(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.title,
      this.cover,
      this.content,
      this.address,
      this.otherName,
      this.videoDirector,
      this.videoMaincharacter,
      this.videoType,
      this.videoArea,
      this.videoLanguage,
      this.videoReleaseTime,
      this.videoUpdate});

  Videos.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    title = json['title'];
    cover = json['cover'];
    content = json['content'];
    address = json['address'];
    otherName = json['otherName'];
    videoDirector = json['videoDirector'];
    videoMaincharacter = json['videoMaincharacter'];
    videoType = json['videoType'];
    videoArea = json['videoArea'];
    videoLanguage = json['videoLanguage'];
    videoReleaseTime = json['videoReleaseTime'];
    videoUpdate = json['videoUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['DeletedAt'] = this.deletedAt;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['content'] = this.content;
    data['address'] = this.address;
    data['otherName'] = this.otherName;
    data['videoDirector'] = this.videoDirector;
    data['videoMaincharacter'] = this.videoMaincharacter;
    data['videoType'] = this.videoType;
    data['videoArea'] = this.videoArea;
    data['videoLanguage'] = this.videoLanguage;
    data['videoReleaseTime'] = this.videoReleaseTime;
    data['videoUpdate'] = this.videoUpdate;
    return data;
  }
}
