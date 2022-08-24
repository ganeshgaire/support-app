class CompanyRecommendationModel {
  int name;
  CompanyRecommendationModel(this.name);
  static List<CompanyRecommendationModel> companyrecomlist = [
    CompanyRecommendationModel(1),
    CompanyRecommendationModel(2),
    CompanyRecommendationModel(3),
    CompanyRecommendationModel(4),
    CompanyRecommendationModel(5),
  ];
}

class CompanySatisfaction {
  bool ischecked;
  String name;
  CompanySatisfaction(this.ischecked, this.name);
  static List<CompanySatisfaction> companysatnlist = [
    CompanySatisfaction(false, "Very Satisfied"),
    CompanySatisfaction(false, "Somewhat Satisfied"),
    CompanySatisfaction(false, "Neither Satisfied Nor Dissatisfied"),
    CompanySatisfaction(false, "Somewhat dissatisfied"),
    CompanySatisfaction(false, "Very Dissatisfied"),
  ];
}

class ProductDescriptionModel {
  bool ischecked;
  String name;
  ProductDescriptionModel(this.ischecked, this.name);
  static List<ProductDescriptionModel> productDescList = [
    ProductDescriptionModel(false, "Reliable"),
    ProductDescriptionModel(false, "High Quality"),
    ProductDescriptionModel(false, "Useful"),
    ProductDescriptionModel(false, "Unique"),
    ProductDescriptionModel(false, "Good value for money"),
    ProductDescriptionModel(false, "Overpriced"),
    ProductDescriptionModel(false, "Impractical"),
    ProductDescriptionModel(false, "Ineffective"),
    ProductDescriptionModel(false, "Poor quality"),
    ProductDescriptionModel(false, "Unreliable"),
  ];
}

class MeetsCustomerNeeds {
  bool ischecked;
  String name;
  MeetsCustomerNeeds(this.ischecked, this.name);
  static List<MeetsCustomerNeeds> meetscustmlist = [
    MeetsCustomerNeeds(false, "Extremly Well"),
    MeetsCustomerNeeds(false, "Very Well"),
    MeetsCustomerNeeds(false, "Somewhat Well"),
    MeetsCustomerNeeds(false, "Not So Well"),
    MeetsCustomerNeeds(false, "Not At All Well"),
  ];
}

class ProductQualityModel {
  bool ischecked;
  String name;
  ProductQualityModel(this.ischecked, this.name);
  static List<ProductQualityModel> productquallist = [
    ProductQualityModel(false, "Very High Quality"),
    ProductQualityModel(false, "High Quality"),
    ProductQualityModel(false, "Neither High Nor Low Quality"),
    ProductQualityModel(false, "Low Quality"),
    ProductQualityModel(false, "Very Low Quality"),
  ];
}

class ProductValuabilityModel {
  bool ischecked;
  String name;
  ProductValuabilityModel(this.ischecked, this.name);
  static List<ProductValuabilityModel> productvaluelist = [
    ProductValuabilityModel(false, "Excellent"),
    ProductValuabilityModel(false, "Above average"),
    ProductValuabilityModel(false, "Average"),
    ProductValuabilityModel(false, "Below Average"),
    ProductValuabilityModel(false, "Poor"),
  ];
}

class CustomerServiceModel {
  bool ischecked;
  String name;
  CustomerServiceModel(this.ischecked, this.name);
  static List<CustomerServiceModel> customerservicelist = [
    CustomerServiceModel(false, "Extremly Responsive "),
    CustomerServiceModel(false, "Very Responsive"),
    CustomerServiceModel(false, "Somewhat Responsive"),
    CustomerServiceModel(false, "Not So Responsive"),
    CustomerServiceModel(false, "Not At All Responsive"),
    CustomerServiceModel(false, "Not Applicable"),
  ];
}

class ProductUsageSinceModel {
  bool ischecked;
  String name;
  ProductUsageSinceModel(this.ischecked, this.name);
  static List<ProductUsageSinceModel> usersincelist = [
    ProductUsageSinceModel(false, "This is my first purchase"),
    ProductUsageSinceModel(false, "Less than six months"),
    ProductUsageSinceModel(false, "Six months to a year"),
    ProductUsageSinceModel(false, "1-2 years"),
    ProductUsageSinceModel(false, "3 or more years"),
    ProductUsageSinceModel(false, "I haven't made a purchase yet"),
  ];
}

class WantOtherProductsModel {
  bool ischecked;
  String name;
  WantOtherProductsModel(this.ischecked, this.name);
  static List<WantOtherProductsModel> wantotherproductlist = [
    WantOtherProductsModel(false, "Extremly likely "),
    WantOtherProductsModel(false, "Very likely"),
    WantOtherProductsModel(false, "Somewhat Likely"),
    WantOtherProductsModel(false, "Not So Likely"),
    WantOtherProductsModel(false, "Not At All Likely"),
    WantOtherProductsModel(false, "Not Applicable"),
  ];
}
