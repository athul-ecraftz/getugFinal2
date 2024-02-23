// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

resend_otp _$resend_otpFromJson(Map<String, dynamic> json) => resend_otp(
      status: json['status'] as String?,
      time: json['time'] as String?,
      otp: json['otp'] as int?,
    );

Map<String, dynamic> _$resend_otpToJson(resend_otp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'otp': instance.otp,
    };
