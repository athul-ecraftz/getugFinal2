// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

update_password _$update_passwordFromJson(Map<String, dynamic> json) =>
    update_password(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$update_passwordToJson(update_password instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
