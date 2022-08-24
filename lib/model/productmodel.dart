class ProductModel {
  int? id;
  String? name;
  String? productType;
  String? description;
  String? image;
  String? createdAt;
  bool? isChecked = false;

  ProductModel(
      {this.id,
      this.name,
      this.productType,
      this.description,
      this.image,
      this.isChecked,
      this.createdAt});

  ProductModel.fromJson(Map<String, dynamic> json) {
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
