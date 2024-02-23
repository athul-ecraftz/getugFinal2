// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Get_category _$Get_categoryFromJson(Map<String, dynamic> json) => Get_category(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Get_categoryToJson(Get_category instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      productStatusId: json['productStatusId'] as int?,
      cover: json['cover'] as String?,
      conditionName: json['conditionName'] as String?,
      wishlist: json['wishlist'] as String?,
      stateId: json['stateId'] as int?,
      productType: json['productType'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'productStatusId': instance.productStatusId,
      'cover': instance.cover,
      'conditionName': instance.conditionName,
      'wishlist': instance.wishlist,
      'stateId': instance.stateId,
      'productType': instance.productType,
    };
