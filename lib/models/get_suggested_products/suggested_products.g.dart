// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggested_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

suggested_products _$suggested_productsFromJson(Map<String, dynamic> json) =>
    suggested_products(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$suggested_productsToJson(suggested_products instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
