// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceExchange _$PriceExchangeFromJson(Map<String, dynamic> json) =>
    PriceExchange(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      volume24h: (json['volume_24h'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PriceExchangeToJson(PriceExchange instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'volume_24h': instance.volume24h,
      'timestamp': instance.timestamp.toIso8601String(),
    };
