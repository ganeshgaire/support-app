class RemarksModel {
  int? id;
  String? user;
  String? description;
  int? audience;
  String? audienceText;
  String? createdDateTime;
  String? createdAt;

  RemarksModel(
      {this.id,
      this.user,
      this.description,
      this.audience,
      this.audienceText,
      this.createdDateTime,
      this.createdAt});

  RemarksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    description = json['description'];
    audience = json['audience'];
    audienceText = json['audience_text'];
    createdDateTime = json['created_date_time'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['description'] = description;
    data['audience'] = audience;
    data['audience_text'] = audienceText;
    data['created_date_time'] = createdDateTime;
    data['created_at'] = createdAt;
    return data;
  }
}
