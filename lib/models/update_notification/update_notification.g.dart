// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

update_notification _$update_notificationFromJson(Map<String, dynamic> json) =>
    update_notification(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$update_notificationToJson(
        update_notification instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
