// To parse this JSON data, do
//
//     final updateVerifyModel = updateVerifyModelFromJson(jsonString);

import 'dart:convert';

UpdateVerifyModel updateVerifyModelFromJson(String str) =>
    UpdateVerifyModel.fromJson(json.decode(str));

String updateVerifyModelToJson(UpdateVerifyModel data) =>
    json.encode(data.toJson());

class UpdateVerifyModel {
  UpdateVerifyModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.validity,
    this.message,
  });

  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  int? validity;
  String? message;

  factory UpdateVerifyModel.fromJson(Map<String, dynamic> json) =>
      UpdateVerifyModel(
        userId: json['user_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        role: json['role'],
        validity: json['validity'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "role": role,
        "validity": validity,
        "message": message,
      };
}
