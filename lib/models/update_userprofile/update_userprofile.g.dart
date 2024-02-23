// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_userprofile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

update_userprofile _$update_userprofileFromJson(Map<String, dynamic> json) =>
    update_userprofile(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$update_userprofileToJson(update_userprofile instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
