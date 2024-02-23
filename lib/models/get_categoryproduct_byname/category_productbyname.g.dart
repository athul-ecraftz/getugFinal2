// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_productbyname.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

category_productbyname _$category_productbynameFromJson(
        Map<String, dynamic> json) =>
    category_productbyname(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$category_productbynameToJson(
        category_productbyname instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
