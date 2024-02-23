// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

insert_product _$insert_productFromJson(Map<String, dynamic> json) =>
    insert_product(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as int?,
    );

Map<String, dynamic> _$insert_productToJson(insert_product instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
