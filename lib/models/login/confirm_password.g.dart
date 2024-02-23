// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Confirm_password _$Confirm_passwordFromJson(Map<String, dynamic> json) =>
    Confirm_password(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$Confirm_passwordToJson(Confirm_password instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
