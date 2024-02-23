// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getChatHeader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHeader _$ChatHeaderFromJson(Map<String, dynamic> json) => ChatHeader(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatHeaderToJson(ChatHeader instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
