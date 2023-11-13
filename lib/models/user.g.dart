// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userId: json['userId'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    validity: json['validity'] as dynamic,
    deviceVerification: json['device_verification'] as String,
    token: json['token'] as String,
    facebook: json['facebook'] as String,
    twitter: json['twitter'] as String,
    linkedIn: json['linkedIn'] as String,
    biography: json['biography'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'validity': instance.validity,
      'device_verification': instance.deviceVerification,
      'token': instance.token,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'linkedIn': instance.linkedIn,
      'biography': instance.biography,
      'image': instance.image,
    };
