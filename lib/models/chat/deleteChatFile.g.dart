// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleteChatFile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteChatFile _$DeleteChatFileFromJson(Map<String, dynamic> json) =>
    DeleteChatFile(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$DeleteChatFileToJson(DeleteChatFile instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
