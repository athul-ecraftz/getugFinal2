// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registerby_email_verifyotp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

registerby_email_verifyotp _$registerby_email_verifyotpFromJson(
        Map<String, dynamic> json) =>
    registerby_email_verifyotp(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
      user: json['user'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$registerby_email_verifyotpToJson(
        registerby_email_verifyotp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
      'user': instance.user,
    };
