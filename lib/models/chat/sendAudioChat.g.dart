// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sendAudioChat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

sendAudioChat _$sendAudioChatFromJson(Map<String, dynamic> json) =>
    sendAudioChat(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$sendAudioChatToJson(sendAudioChat instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
