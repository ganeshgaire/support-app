class LiscenseDetailModel {
  String? restaurantName;
  int? restaurantStatus;
  String? restaurantStatusText;
  String? licenseName;
  String? licenseSerialKey;
  int? licenseStatus;
  String? licenseStatusText;
  String? licenseExpiryDate;
  String? licenseRemainingTime;
  String? licenseCreatedOn;
  String? licenseCreatedAt;
  String? licenseAssignedOn;
  String? licenseAssignedAt;
  String? serverType;

  LiscenseDetailModel(
      {this.restaurantName,
      this.restaurantStatus,
      this.restaurantStatusText,
      this.licenseName,
      this.licenseSerialKey,
      this.licenseStatus,
      this.licenseStatusText,
      this.licenseExpiryDate,
      this.licenseRemainingTime,
      this.licenseCreatedOn,
      this.licenseCreatedAt,
      this.licenseAssignedOn,
      this.licenseAssignedAt,
      this.serverType});

  LiscenseDetailModel.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurant_name'];
    restaurantStatus = json['restaurant_status'];
    restaurantStatusText = json['restaurant_status_text'];
    licenseName = json['license_name'];
    licenseSerialKey = json['license_serial_key'];
    licenseStatus = json['license_status'];
    licenseStatusText = json['license_status_text'];
    licenseExpiryDate = json['license_expiry_date'];
    licenseRemainingTime = json['license_remaining_time'];
    licenseCreatedOn = json['license_created_on'];
    licenseCreatedAt = json['license_created_at'];
    licenseAssignedOn = json['license_assigned_on'];
    licenseAssignedAt = json['license_assigned_at'];
    serverType = json['server_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_name'] = restaurantName;
    data['restaurant_status'] = restaurantStatus;
    data['restaurant_status_text'] = restaurantStatusText;
    data['license_name'] = licenseName;
    data['license_serial_key'] = licenseSerialKey;
    data['license_status'] = licenseStatus;
    data['license_status_text'] = licenseStatusText;
    data['license_expiry_date'] = licenseExpiryDate;
    data['license_remaining_time'] = licenseRemainingTime;
    data['license_created_on'] = licenseCreatedOn;
    data['license_created_at'] = licenseCreatedAt;
    data['license_assigned_on'] = licenseAssignedOn;
    data['license_assigned_at'] = licenseAssignedAt;
    data['server_type'] = serverType;
    return data;
  }
}
