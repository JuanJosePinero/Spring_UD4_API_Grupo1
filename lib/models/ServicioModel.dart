class ServicioData {
  int? id;
  String? title;
  String? description;
  String? registerDate;
  String? happeningDate;
  int? studentId;
  int? businessId;
  int? proFamilyId;
  double? valoration;
  int? finished;
  String? comment;
  int? deleted;

  ServicioData({
    this.id,
    this.title,
    this.description,
    this.registerDate,
    this.happeningDate,
    this.studentId,
    this.businessId,
    this.proFamilyId,
    this.valoration,
    this.finished,
    this.comment,
    this.deleted,
  });

  ServicioData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    registerDate = json['registerDate'];
    happeningDate = json['happeningDate'];
    studentId = json['studentId'];
    businessId = json['businessId'];
    proFamilyId = json['proFamilyId'];
    valoration = json['valoration'];
    finished = json['finished'];
    comment = json['comment'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['registerDate'] = registerDate;
    data['happeningDate'] = happeningDate;
    data['studentId'] = studentId;
    data['businessId'] = businessId;
    data['proFamilyId'] = proFamilyId;
    data['valoration'] = valoration;
    data['finished'] = finished;
    data['comment'] = comment;
    data['deleted'] = deleted;
    return data;
  }
}
