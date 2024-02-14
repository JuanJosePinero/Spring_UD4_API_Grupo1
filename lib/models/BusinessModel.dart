class StudentData {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? password;
  int? proFamilyId;
  List<Servicio>? servicios;
  int? userId;

  StudentData({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.password,
    this.proFamilyId,
    this.servicios,
    this.userId,
  });

  StudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    password = json['password'];
    proFamilyId = json['proFamilyId'];
    if (json['servicios'] != null) {
      servicios = <Servicio>[];
      json['servicios'].forEach((v) {
        servicios!.add(Servicio.fromJson(v));
      });
    }
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['password'] = password;
    data['proFamilyId'] = proFamilyId;
    if (servicios != null) {
      data['servicios'] = servicios!.map((v) => v.toJson()).toList();
    }
      data['userId'] = userId;
    return data;
  }
}

class StudentResponse {
  bool? success;
  List<StudentData>? data;
  String? message;

  StudentResponse({this.success, this.data, this.message});

  StudentResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StudentData>[];
      json['data'].forEach((v) {
        data!.add(StudentData.fromJson(v));
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
