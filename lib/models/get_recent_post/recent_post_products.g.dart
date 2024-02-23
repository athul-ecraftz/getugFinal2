// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_post_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

recent_post_products _$recent_post_productsFromJson(
        Map<String, dynamic> json) =>
    recent_post_products(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$recent_post_productsToJson(
        recent_post_products instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
