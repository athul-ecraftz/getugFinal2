// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservedupdateProductStatusById.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservedUpdateProductById _$ReservedUpdateProductByIdFromJson(
        Map<String, dynamic> json) =>
    ReservedUpdateProductById(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$ReservedUpdateProductByIdToJson(
        ReservedUpdateProductById instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
