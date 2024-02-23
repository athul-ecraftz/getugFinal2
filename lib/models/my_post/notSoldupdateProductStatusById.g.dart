// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notSoldupdateProductStatusById.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotSoldUpdateProductById _$NotSoldUpdateProductByIdFromJson(
        Map<String, dynamic> json) =>
    NotSoldUpdateProductById(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$NotSoldUpdateProductByIdToJson(
        NotSoldUpdateProductById instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
