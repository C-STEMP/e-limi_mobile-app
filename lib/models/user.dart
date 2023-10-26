import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? facebook;
  String? twitter;
  String? linkedIn;
  String? biography;
  String? image;

  User({
    @required this.userId,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.role,
    this.facebook,
    this.twitter,
    this.linkedIn,
    this.biography,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
