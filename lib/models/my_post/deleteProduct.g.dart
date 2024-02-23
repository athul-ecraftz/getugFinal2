// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleteProduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteProduct _$DeleteProductFromJson(Map<String, dynamic> json) =>
    DeleteProduct(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$DeleteProductToJson(DeleteProduct instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
