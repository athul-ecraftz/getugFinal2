// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mypost _$MypostFromJson(Map<String, dynamic> json) => Mypost(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MypostToJson(Mypost instance) => <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
