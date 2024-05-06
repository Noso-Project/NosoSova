import 'package:json_annotation/json_annotation.dart';

part 'price_exchange.g.dart';

@JsonSerializable()
class PriceExchange {
  late final String name;
  final double price;
  @JsonKey(name: 'volume_24h')
  final double volume24h;
  final DateTime timestamp;

  PriceExchange({
    required this.name,
    required this.price,
    required this.volume24h,
    required this.timestamp,
  });

  factory PriceExchange.fromJson(Map<String, dynamic> json) =>
      _$PriceExchangeFromJson(json);

  Map<String, dynamic> toJson() => _$PriceExchangeToJson(this);
}
