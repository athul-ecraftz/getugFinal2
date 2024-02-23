// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getAllChat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllChats _$AllChatsFromJson(Map<String, dynamic> json) => AllChats(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllChatsToJson(AllChats instance) => <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
