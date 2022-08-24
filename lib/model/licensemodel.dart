class LicenseListModel {
  int? id;
  String? name;
  String? serialKey;
  int? status;
  String? statusText;
  UsedBy? usedBy;
  int? expiryStatus;
  String? expiryDate;
  String? remainingTime;
  String? createdOn;
  String? createdAt;

  LicenseListModel(
      {this.id,
      this.name,
      this.serialKey,
      this.status,
      this.statusText,
      this.usedBy,
      this.expiryStatus,
      this.expiryDate,
      this.remainingTime,
      this.createdOn,
      this.createdAt});

  LicenseListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serialKey = json['serial_key'];
    status = json['status'];
    statusText = json['status_text'];
    usedBy = json['used_by'] != null ? UsedBy.fromJson(json['used_by']) : null;
    expiryStatus = json['expiry_status'];
    expiryDate = json['expiry_date'];
    remainingTime = json['remaining_time'];
    createdOn = json['created_on'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serial_key'] = serialKey;
    data['status'] = status;
    data['status_text'] = statusText;
    if (usedBy != null) {
      data['used_by'] = usedBy!.toJson();
    }
    data['expiry_status'] = expiryStatus;
    data['expiry_date'] = expiryDate;
    data['remaining_time'] = remainingTime;
    data['created_on'] = createdOn;
    data['created_at'] = createdAt;
    return data;
  }
}

class UsedBy {
  String? name;
  String? panVatNo;
  String? mobileNo;
  String? representativeName;
  String? address;

  UsedBy(
      {this.name,
      this.panVatNo,
      this.mobileNo,
      this.representativeName,
      this.address});

  UsedBy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    panVatNo = json['pan_vat_no'];
    mobileNo = json['mobile_no'];
    representativeName = json['representative_name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pan_vat_no'] = panVatNo;
    data['mobile_no'] = mobileNo;
    data['representative_name'] = representativeName;
    data['address'] = address;
    return data;
  }
}
