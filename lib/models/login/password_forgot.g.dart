// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_forgot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forgot_password _$Forgot_passwordFromJson(Map<String, dynamic> json) =>
    Forgot_password(
      status: json['status'] as String?,
      time: json['time'] as String?,
      otp: json['otp'] as int?,
      user: json['user'] as Map<String, dynamic>?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$Forgot_passwordToJson(Forgot_password instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'otp': instance.otp,
      'data': instance.data,
      'user': instance.user,
    };
