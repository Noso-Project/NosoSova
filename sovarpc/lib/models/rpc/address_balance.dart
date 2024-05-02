import 'package:noso_dart/utils/noso_math.dart';

class AddressBalance {
  bool? valid;
  String address;
  String? alias;
  double balance;
  int incoming;
  int outgoing;

  AddressBalance({
    this.valid = false,
    required this.address,
    this.alias,
    required this.balance,
    required this.incoming,
    required this.outgoing,
  });

  // Method to convert a JSON map to an instance of BalanceInfo
  factory AddressBalance.fromJson(Map<String, dynamic> json) => AddressBalance(
    valid: json['valid'] ?? false,
    address: json['address'],
    alias: json['alias'],
    balance: (json['balance'] is int ? (json['balance'] as int).toDouble() : json['balance'] as double),
    incoming: json['incoming'],
    outgoing: json['outgoing'],
  );

  // Method to convert an instance of BalanceInfo to a JSON map
  Map<String, Object?> toJson() => {
    'valid': valid,
    'address': address,
    'alias': alias,
    'balance': NosoMath().doubleToBigEndian(balance),
    'incoming': incoming,
    'outgoing': outgoing,
  };
}
