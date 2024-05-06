import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable()
class PriceData {
  final String timestamp;
  final double price;

  PriceData({required this.timestamp, required this.price});

  factory PriceData.fromJson(Map<String, dynamic> json) =>
      _$PriceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PriceDataToJson(this);
}
