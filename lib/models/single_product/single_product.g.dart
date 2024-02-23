// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Single_product _$Single_productFromJson(Map<String, dynamic> json) =>
    Single_product(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Single_productToJson(Single_product instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
