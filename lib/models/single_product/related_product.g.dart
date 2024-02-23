// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Related_product _$Related_productFromJson(Map<String, dynamic> json) =>
    Related_product(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data1.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Related_productToJson(Related_product instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
