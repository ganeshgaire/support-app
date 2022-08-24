class TaskListModel {
  int? id;
  String? user;
  String? title;
  String? description;
  String? remarks;
  int? status;
  String? statusText;
  int? priority;
  String? priorityText;
  String? createdBy;
  String? issuedDay;
  String? issuedMonthYear;
  String? createdDateTime;
  String? createdAt;
  String? updatedDateTime;
  String? updatedAt;
  List<String>? image;

  TaskListModel(
      {this.id,
      this.user,
      this.title,
      this.description,
      this.remarks,
      this.status,
      this.statusText,
      this.priority,
      this.priorityText,
      this.createdBy,
      this.issuedDay,
      this.issuedMonthYear,
      this.createdDateTime,
      this.createdAt,
      this.updatedDateTime,
      this.updatedAt,
      this.image});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    title = json['title'];
    description = json['description'];
    remarks = json['remarks'];
    status = json['status'];
    statusText = json['status_text'];
    priority = json['priority'];
    priorityText = json['priority_text'];
    createdBy = json['created_by'];
    issuedDay = json['issued_day'];
    issuedMonthYear = json['issued_month_year'];
    createdDateTime = json['created_date_time'];
    createdAt = json['created_at'];
    updatedDateTime = json['updated_date_time'];
    updatedAt = json['updated_at'];
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['title'] = title;
    data['description'] = description;
    data['remarks'] = remarks;
    data['status'] = status;
    data['status_text'] = statusText;
    data['priority'] = priority;
    data['priority_text'] = priorityText;
    data['created_by'] = createdBy;
    data['issued_day'] = issuedDay;
    data['issued_month_year'] = issuedMonthYear;
    data['created_date_time'] = createdDateTime;
    data['created_at'] = createdAt;
    data['updated_date_time'] = updatedDateTime;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    return data;
  }
}
