import 'package:json_annotation/json_annotation.dart';

part 'address_info.g.dart';

@JsonSerializable()
class AddressInfo {
  final String address;
  final String? alias;
  final int block;
  final double balance;
  final int incoming;
  final int outgoing;
  final int locked;
  @JsonKey(name: 'blocks_locked')
  final Map<String, dynamic> blocksLocked;

  AddressInfo({
    required this.address,
    this.alias,
    required this.block,
    required this.balance,
    required this.incoming,
    required this.outgoing,
    required this.locked,
    required this.blocksLocked,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) => _$AddressInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AddressInfoToJson(this);
}
