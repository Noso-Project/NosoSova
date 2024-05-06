// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceData _$PriceDataFromJson(Map<String, dynamic> json) => PriceData(
      timestamp: json['timestamp'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceDataToJson(PriceData instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'price': instance.price,
    };
