// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_usersend_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

verify_usersend_otp _$verify_usersend_otpFromJson(Map<String, dynamic> json) =>
    verify_usersend_otp(
      status: json['status'] as String?,
      time: json['time'] as String?,
      otp: json['otp'] as int?,
      userId: json['userId'] as int?,
    );

Map<String, dynamic> _$verify_usersend_otpToJson(
        verify_usersend_otp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'otp': instance.otp,
      'userId': instance.userId,
    };
