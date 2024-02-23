// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updateProductById.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProductById _$UpdateProductByIdFromJson(Map<String, dynamic> json) =>
    UpdateProductById(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as int?,
    );

Map<String, dynamic> _$UpdateProductByIdToJson(UpdateProductById instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
