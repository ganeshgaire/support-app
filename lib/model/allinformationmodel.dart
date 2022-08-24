class AllInformationModel {
  List<Organizations>? organizations;
  List<Users>? users;
  List<ProblemTypes>? problemTypes;

  AllInformationModel({this.organizations, this.users, this.problemTypes});

  AllInformationModel.fromJson(Map<String, dynamic> json) {
    if (json['organizations'] != null) {
      organizations = <Organizations>[];
      json['organizations'].forEach((v) {
        organizations!.add(Organizations.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    if (json['problem_types'] != null) {
      problemTypes = <ProblemTypes>[];
      json['problem_types'].forEach((v) {
        problemTypes!.add(ProblemTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (organizations != null) {
      data['organizations'] = organizations!.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (problemTypes != null) {
      data['problem_types'] = problemTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Organizations {
  int? id;
  String? organizationname;
  List<UsedProducts>? usedProducts;

  Organizations({this.id, this.organizationname, this.usedProducts});

  Organizations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationname = json['organizationname'];
    if (json['used_products'] != null) {
      usedProducts = <UsedProducts>[];
      json['used_products'].forEach((v) {
        usedProducts!.add(UsedProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organizationname'] = organizationname;
    if (usedProducts != null) {
      data['used_products'] = usedProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsedProducts {
  int? id;
  String? name;

  UsedProducts({this.id, this.name});

  UsedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Users {
  int? id;
  String? name;

  Users({this.id, this.name});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ProblemTypes {
  int? id;
  String? name;
  List<ProblemCategories>? problemCategories;

  ProblemTypes({this.id, this.name, this.problemCategories});

  ProblemTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['problem_categories'] != null) {
      problemCategories = <ProblemCategories>[];
      json['problem_categories'].forEach((v) {
        problemCategories!.add(ProblemCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (problemCategories != null) {
      data['problem_categories'] =
          problemCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProblemCategories {
  int? id;
  String? name;

  ProblemCategories({this.id, this.name});

  ProblemCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
