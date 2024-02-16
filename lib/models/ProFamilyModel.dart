class ProFamilyModel {
  int? id;
  String? name;
  int? deleted;

  ProFamilyModel({
    this.id,
    this.name,
    this.deleted,
  });

  ProFamilyModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['deleted'] = deleted;
    return data;
  }
}

class ProFamilyResponse {
  bool? success;
  List<ProFamilyModel>? data;
  String? message;

  ProFamilyResponse({this.success, this.data, this.message});

  ProFamilyResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];if (json['data'] != null) {
      data = <ProFamilyModel>[];
      json['data'].forEach((v) {
        data!.add(ProFamilyModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}