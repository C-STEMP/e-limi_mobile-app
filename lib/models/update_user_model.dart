// To parse this JSON data, do
//
//     final updateUserModel = updateUserModelFromJson(jsonString);

import 'dart:convert';

UpdateUserModel updateUserModelFromJson(String str) =>
    UpdateUserModel.fromJson(json.decode(str));

String updateUserModelToJson(UpdateUserModel data) =>
    json.encode(data.toJson());

class UpdateUserModel {
  UpdateUserModel({
    this.message,
    this.emailVerification,
    this.status,
    this.validity,
  });

  String? message;
  String? emailVerification;
  int? status;
  bool? validity;

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserModel(
        message: json["message"],
        emailVerification: json["email_verification"],
        status: json["status"],
        validity: json["validity"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "email_verification": emailVerification,
        "status": status,
        "validity": validity,
      };
}
