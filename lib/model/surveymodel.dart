class SurveyModel {
  int? id;
  String? organizationName;
  String? surveyBy;
  String? representativeName;
  Feedback? feedback;
  String? signatureImage;
  String? latitude;
  String? longitude;
  String? surveyDay;
  String? surveyMonthYear;
  String? surveyDate;
  String? surveyTime;
  String? surveyDateTime;
  String? surveyAt;
  List<String>? images;

  SurveyModel(
      {this.id,
      this.organizationName,
      this.surveyBy,
      this.representativeName,
      this.feedback,
      this.signatureImage,
      this.latitude,
      this.longitude,
      this.surveyDay,
      this.surveyMonthYear,
      this.surveyDate,
      this.surveyTime,
      this.surveyDateTime,
      this.surveyAt,
      this.images});

  SurveyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationName = json['organization_name'];
    surveyBy = json['survey_by'];
    representativeName = json['representative_name'];
    feedback =
        json['feedback'] != null ? Feedback.fromJson(json['feedback']) : null;
    signatureImage = json['signature_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    surveyDay = json['survey_day'];
    surveyMonthYear = json['survey_month_year'];
    surveyDate = json['survey_date'];
    surveyTime = json['survey_time'];
    surveyDateTime = json['survey_date_time'];
    surveyAt = json['survey_at'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organization_name'] = organizationName;
    data['survey_by'] = surveyBy;
    data['representative_name'] = representativeName;
    if (feedback != null) {
      data['feedback'] = feedback!.toJson();
    }
    data['signature_image'] = signatureImage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['survey_day'] = surveyDay;
    data['survey_month_year'] = surveyMonthYear;
    data['survey_date'] = surveyDate;
    data['survey_time'] = surveyTime;
    data['survey_date_time'] = surveyDateTime;
    data['survey_at'] = surveyAt;
    data['images'] = images;
    return data;
  }
}

class Feedback {
  int? companyRecommendation;
  String? companySatisfaction;
  List<String>? productDescription;
  String? meetsCustomerNeeds;
  String? productQuality;
  String? productValuability;
  String? customerService;
  String? productUsageSince;
  String? wantOtherProducts;
  String? feedback;

  Feedback(
      {this.companyRecommendation,
      this.companySatisfaction,
      this.productDescription,
      this.meetsCustomerNeeds,
      this.productQuality,
      this.productValuability,
      this.customerService,
      this.productUsageSince,
      this.wantOtherProducts,
      this.feedback});

  Feedback.fromJson(Map<String, dynamic> json) {
    companyRecommendation = json['company_recommendation'];
    companySatisfaction = json['company_satisfaction'];
    productDescription = json['product_description'].cast<String>();
    meetsCustomerNeeds = json['meets_customer_needs'];
    productQuality = json['product_quality'];
    productValuability = json['product_valuability'];
    customerService = json['customer_service'];
    productUsageSince = json['product_usage_since'];
    wantOtherProducts = json['want_other_products'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_recommendation'] = companyRecommendation;
    data['company_satisfaction'] = companySatisfaction;
    data['product_description'] = productDescription;
    data['meets_customer_needs'] = meetsCustomerNeeds;
    data['product_quality'] = productQuality;
    data['product_valuability'] = productValuability;
    data['customer_service'] = customerService;
    data['product_usage_since'] = productUsageSince;
    data['want_other_products'] = wantOtherProducts;
    data['feedback'] = feedback;
    return data;
  }
}
