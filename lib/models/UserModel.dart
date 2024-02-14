class UserData {
  int? id;
  String? username;
  String? password;
  String? email;
  int? enabled;
  String? role;
  String? token;
  int? studentID;
  int? businessID;

  UserData({
    this.id,
    this.username,
    this.password,
    this.email,
    this.enabled,
    this.role,
    this.token,
    this.studentID,
    this.businessID,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    enabled = json['enabled'];
    role = json['role'];
    token = json['token'];
    studentID = json['studentID'];
    businessID = json['businessID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['enabled'] = enabled;
    data['role'] = role;
    data['token'] = token;
    data['studentID'] = studentID;
    data['businessID'] = businessID;
    return data;
  }
}

class UserResponse {
  bool? success;
  List<UserData>? data;
  String? message;

  UserResponse({this.success, this.data, this.message});

  UserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
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
