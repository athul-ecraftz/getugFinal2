// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recent_products _$Recent_productsFromJson(Map<String, dynamic> json) =>
    Recent_products(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Recent_productsToJson(Recent_products instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
