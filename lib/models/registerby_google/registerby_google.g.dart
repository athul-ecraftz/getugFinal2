// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registerby_google.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

registerby_google _$registerby_googleFromJson(Map<String, dynamic> json) =>
    registerby_google(
      status: json['status'] as String?,
      time: json['time'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$registerby_googleToJson(registerby_google instance) =>
    <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'user': instance.user,
    };
