// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producttype.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) => ProductType(
      productTypeId: json['productTypeId'] as int?,
      productTypeName: json['productTypeName'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'productTypeId': instance.productTypeId,
      'productTypeName': instance.productTypeName,
      'data': instance.data,
    };
