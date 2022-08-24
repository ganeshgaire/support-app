class MyTicketModel {
  int? id;
  String? ticketId;
  int? organizationId;
  String? organizationName;
  int? productId;
  String? productName;
  String? organizationNumber;
  String? departmentName;
  String? assignedTo;
  String? problemType;
  String? problemCategory;
  int? priority;
  String? priorityText;
  int? status;
  String? statusText;
  String? issuedDay;
  String? issuedMonthYear;
  String? issuedDate;
  String? issuedTime;
  String? issuedAt;
  String? details;
  int? totalRemarks;
  List<String>? images;

  MyTicketModel(
      {this.id,
      this.ticketId,
      this.organizationId,
      this.organizationName,
      this.productId,
      this.productName,
      this.organizationNumber,
      this.departmentName,
      this.assignedTo,
      this.problemType,
      this.problemCategory,
      this.priority,
      this.priorityText,
      this.status,
      this.statusText,
      this.issuedDay,
      this.issuedMonthYear,
      this.issuedDate,
      this.issuedTime,
      this.issuedAt,
      this.details,
      this.totalRemarks,
      this.images});

  MyTicketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    organizationId = json['organization_id'];
    organizationName = json['organization_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    organizationNumber = json['organization_number'];
    departmentName = json['department_name'];
    assignedTo = json['assigned_to'];
    problemType = json['problem_type'];
    problemCategory = json['problem_category'];
    priority = json['priority'];
    priorityText = json['priority_text'];
    status = json['status'];
    statusText = json['status_text'];
    issuedDay = json['issued_day'];
    issuedMonthYear = json['issued_month_year'];
    issuedDate = json['issued_date'];
    issuedTime = json['issued_time'];
    issuedAt = json['issued_at'];
    details = json['details'];
    totalRemarks = json['total_remarks'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_id'] = ticketId;
    data['organization_id'] = organizationId;
    data['organization_name'] = organizationName;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['organization_number'] = organizationNumber;
    data['department_name'] = departmentName;
    data['assigned_to'] = assignedTo;
    data['problem_type'] = problemType;
    data['problem_category'] = problemCategory;
    data['priority'] = priority;
    data['priority_text'] = priorityText;
    data['status'] = status;
    data['status_text'] = statusText;
    data['issued_day'] = issuedDay;
    data['issued_month_year'] = issuedMonthYear;
    data['issued_date'] = issuedDate;
    data['issued_time'] = issuedTime;
    data['issued_at'] = issuedAt;
    data['details'] = details;
    data['total_remarks'] = totalRemarks;
    data['images'] = images;
    return data;
  }
}
