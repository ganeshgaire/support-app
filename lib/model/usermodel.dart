class UserModel {
  int? id;
  String? name;
  String? email;
  String? contact;
  String? address;
  int? status;
  String? department;
  String? rewardPoints;
  String? userType;
  String? profileImage;
  String? statusText;
  String? joinedDate;
  String? joinedTime;
  String? joinedAt;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.contact,
      this.address,
      this.status,
      this.department,
      this.rewardPoints,
      this.userType,
      this.profileImage,
      this.statusText,
      this.joinedDate,
      this.joinedTime,
      this.joinedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    address = json['address'];
    status = json['status'];
    department = json['department'];
    rewardPoints = json['reward_points'];
    userType = json['user_type'];
    profileImage = json['profile_image'];
    statusText = json['status_text'];
    joinedDate = json['joined_date'];
    joinedTime = json['joined_time'];
    joinedAt = json['joined_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['address'] = address;
    data['status'] = status;
    data['department'] = department;
    data['reward_points'] = rewardPoints;
    data['user_type'] = userType;
    data['profile_image'] = profileImage;
    data['status_text'] = statusText;
    data['joined_date'] = joinedDate;
    data['joined_time'] = joinedTime;
    data['joined_at'] = joinedAt;
    return data;
  }
}
