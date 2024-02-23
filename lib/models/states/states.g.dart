// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllStates _$AllStatesFromJson(Map<String, dynamic> json) => AllStates(
      status: json['status'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => States.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllStatesToJson(AllStates instance) => <String, dynamic>{
      'status': instance.status,
      'time': instance.time,
      'data': instance.data,
    };
