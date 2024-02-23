// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) => Login(
      userName: json['userName'] as String?,
      mobileNumber: json['mobileNumber'] as int?,
      email: json['email'] as String?,
      photo: json['photo'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      description: json['description'] as String?,
      alternateNumber: json['alternateNumber'] as int?,
      userId: json['userId'] as int?,
      registerPlatformId: json['registerPlatformId'] as int?,
    );

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'userName': instance.userName,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'photo': instance.photo,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'description': instance.description,
      'alternateNumber': instance.alternateNumber,
      'userId': instance.userId,
      'registerPlatformId': instance.registerPlatformId,
    };
