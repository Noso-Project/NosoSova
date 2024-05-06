// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiStatus _$ApiStatusFromJson(Map<String, dynamic> json) => ApiStatus(
      api: json['API'] as String?,
      nosoDB: json['nosoDB'] as String?,
    );

Map<String, dynamic> _$ApiStatusToJson(ApiStatus instance) => <String, dynamic>{
      'API': instance.api,
      'nosoDB': instance.nosoDB,
    };
