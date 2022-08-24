class OrganizationListModel {
  int? id;
  String? name;
  String? mobileNo;
  String? phoneNo;
  String? type;
  String? address;
  String? panVatNo;
  String? representativeName;
  List<UsedProducts>? usedProducts;
  String? latitude;
  String? longitude;
  String? email;

  OrganizationListModel(
      {this.id,
      this.name,
      this.mobileNo,
      this.phoneNo,
      this.type,
      this.address,
      this.panVatNo,
      this.representativeName,
      this.usedProducts,
      this.latitude,
      this.longitude,
      this.email});

  OrganizationListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobileNo = json['mobile_no'];
    phoneNo = json['phone_no'];
    type = json['type'];
    address = json['address'];
    panVatNo = json['pan_vat_no'];
    representativeName = json['representative_name'];
    if (json['used_products'] != null) {
      usedProducts = <UsedProducts>[];
      json['used_products'].forEach((v) {
        usedProducts!.add(UsedProducts.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile_no'] = mobileNo;
    data['phone_no'] = phoneNo;
    data['type'] = type;
    data['address'] = address;
    data['pan_vat_no'] = panVatNo;
    data['representative_name'] = representativeName;
    if (usedProducts != null) {
      data['used_products'] = usedProducts!.map((v) => v.toJson()).toList();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['email'] = email;
    return data;
  }
}

class UsedProducts {
  int? id;
  String? name;
  String? productType;
  String? description;
  String? image;
  String? createdAt;

  UsedProducts(
      {this.id,
      this.name,
      this.productType,
      this.description,
      this.image,
      this.createdAt});

  UsedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productType = json['product_type'];
    description = json['description'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_type'] = productType;
    data['description'] = description;
    data['image'] = image;
    data['created_at'] = createdAt;
    return data;
  }
}
