// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Home_product _$Home_productFromJson(Map<String, dynamic> json) => Home_product(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      productcount: json['productcount'] as int?,
    );

Map<String, dynamic> _$Home_productToJson(Home_product instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
      'productcount': instance.productcount,
    };
