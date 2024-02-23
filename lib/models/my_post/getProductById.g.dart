// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getProductById.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

getproduct _$getproductFromJson(Map<String, dynamic> json) => getproduct(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$getproductToJson(getproduct instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
