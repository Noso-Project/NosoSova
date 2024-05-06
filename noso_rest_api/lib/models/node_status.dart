import 'package:json_annotation/json_annotation.dart';

part 'node_status.g.dart';

@JsonSerializable()
class NodeStatus {
  @JsonKey(name: 'block_id')
  final String blockId;
  final String address;
  final String status;
  @JsonKey(name: 'last_seen')
  final String lastSeen;
  @JsonKey(name: 'last_payment')
  final String lastPayment;
  @JsonKey(name: 'next_payment')
  final String nextPayment;
  @JsonKey(name: 'consecutive_payments')
  final String consecutivePayments;
  @JsonKey(name: 'uptime_percent')
  final String uptimePercent;
  @JsonKey(name: 'monthly_earning')
  final String monthlyEarning;
  @JsonKey(name: 'monthly_earning_usdt')
  final String monthlyEarningUsdt;

  NodeStatus({
    required this.blockId,
    required this.address,
    required this.status,
    required this.lastSeen,
    required this.lastPayment,
    required this.nextPayment,
    required this.consecutivePayments,
    required this.uptimePercent,
    required this.monthlyEarning,
    required this.monthlyEarningUsdt,
  });

  factory NodeStatus.fromJson(Map<String, dynamic> json) => _$NodeStatusFromJson(json);
  Map<String, dynamic> toJson() => _$NodeStatusToJson(this);
}
