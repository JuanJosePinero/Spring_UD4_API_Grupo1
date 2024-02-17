import 'ServicioModel.dart';
import 'UserModel.dart';

class BusinessModel extends UserModel {
  String? name;
  String? address;
  String? phone;
  String? logo;
  List<ServicioModel>? servicioList;
  int? deleted;

  BusinessModel({
    int? id,
    String? email,
    this.name,
    this.address,
    this.phone,
    this.logo,
    this.servicioList,
    this.deleted,
  }) : super(id: id, email: email);

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      logo: json['logo'],
      servicioList: json['servicioList'] != null ? List<ServicioModel>.from(json['servicioList'].map((model) => ServicioModel.fromJson(model))) : null,
      deleted: json['deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'name': name,
      'address': address,
      'phone': phone,
      'logo': logo,
      'servicioList': servicioList?.map((v) => v.toJson()).toList(),
      'deleted': deleted,
    });
    return data;
  }
}

class BusinessResponse {
  bool? success;
  BusinessModel? data;
  String? message;

  BusinessResponse({this.success, this.data, this.message});

  factory BusinessResponse.fromJson(Map<String, dynamic> json) {
    return BusinessResponse(
      success: json['success'],
      data: json['data'] != null ? BusinessModel.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
