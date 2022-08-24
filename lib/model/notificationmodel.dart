class NotificationModel {
  int? id;
  int? userId;
  String? title;
  String? message;
  String? image;
  String? type;
  String? targetId;
  String? notificationDateTime;
  String? notificationAt;

  NotificationModel(
      {this.id,
      this.userId,
      this.title,
      this.message,
      this.image,
      this.type,
      this.targetId,
      this.notificationDateTime,
      this.notificationAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    message = json['message'];
    image = json['image'];
    type = json['type'];
    targetId = json['target_id'];
    notificationDateTime = json['notification_date_time'];
    notificationAt = json['notification_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['message'] = message;
    data['image'] = image;
    data['type'] = type;
    data['target_id'] = targetId;
    data['notification_date_time'] = notificationDateTime;
    data['notification_at'] = notificationAt;
    return data;
  }
}
