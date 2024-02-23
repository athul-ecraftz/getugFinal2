// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

search_products _$search_productsFromJson(Map<String, dynamic> json) =>
    search_products(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$search_productsToJson(search_products instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
