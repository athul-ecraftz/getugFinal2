// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productstatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductStatus _$ProductStatusFromJson(Map<String, dynamic> json) =>
    ProductStatus(
      productStatusId: json['productStatusId'] as int?,
      productStatusName: json['productStatusName'] as String?,
    )..data = json['data'] as String?;

Map<String, dynamic> _$ProductStatusToJson(ProductStatus instance) =>
    <String, dynamic>{
      'productStatusId': instance.productStatusId,
      'productStatusName': instance.productStatusName,
      'data': instance.data,
    };
