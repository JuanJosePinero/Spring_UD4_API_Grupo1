class UserModel {
  int? id;
  String? username;
  String? email;
  String? token;

  UserModel({this.id, this.username, this.email, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
    };
  }
}

class UserResponse {
  bool? success;
  UserModel? data;
  String? message;

  UserResponse({this.success, this.data, this.message});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}
