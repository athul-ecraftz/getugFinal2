// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soldupdateProductStatusById.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoldUpdateProductById _$SoldUpdateProductByIdFromJson(
        Map<String, dynamic> json) =>
    SoldUpdateProductById(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$SoldUpdateProductByIdToJson(
        SoldUpdateProductById instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
