// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_wishlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

get_wishlist _$get_wishlistFromJson(Map<String, dynamic> json) => get_wishlist(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$get_wishlistToJson(get_wishlist instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
