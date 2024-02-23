// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

forgot_password _$forgot_passwordFromJson(Map<String, dynamic> json) =>
    forgot_password(
      status: json['status'] as String?,
      time: json['time'] as String?,
      otp: json['otp'] as int?,
      user: json['user'] as String?,
    );

Map<String, dynamic> _$forgot_passwordToJson(forgot_password instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'otp': instance.otp,
      'user': instance.user,
    };
