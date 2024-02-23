// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCondition _$ProductConditionFromJson(Map<String, dynamic> json) =>
    ProductCondition(
      productConditionId: json['productConditionId'] as int?,
      productConditionName: json['productConditionName'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$ProductConditionToJson(ProductCondition instance) =>
    <String, dynamic>{
      'productConditionId': instance.productConditionId,
      'productConditionName': instance.productConditionName,
      'data': instance.data,
    };
