// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_with_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

signup_with_email _$signup_with_emailFromJson(Map<String, dynamic> json) =>
    signup_with_email(
      status: json['status'] as String?,
      time: json['time'] as String?,
      otp: json['otp'] as int?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$signup_with_emailToJson(signup_with_email instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'otp': instance.otp,
      'data': instance.data,
    };
