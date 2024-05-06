// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeStatus _$NodeStatusFromJson(Map<String, dynamic> json) => NodeStatus(
      blockId: json['block_id'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
      lastSeen: json['last_seen'] as String,
      lastPayment: json['last_payment'] as String,
      nextPayment: json['next_payment'] as String,
      consecutivePayments: json['consecutive_payments'] as String,
      uptimePercent: json['uptime_percent'] as String,
      monthlyEarning: json['monthly_earning'] as String,
      monthlyEarningUsdt: json['monthly_earning_usdt'] as String,
    );

Map<String, dynamic> _$NodeStatusToJson(NodeStatus instance) =>
    <String, dynamic>{
      'block_id': instance.blockId,
      'address': instance.address,
      'status': instance.status,
      'last_seen': instance.lastSeen,
      'last_payment': instance.lastPayment,
      'next_payment': instance.nextPayment,
      'consecutive_payments': instance.consecutivePayments,
      'uptime_percent': instance.uptimePercent,
      'monthly_earning': instance.monthlyEarning,
      'monthly_earning_usdt': instance.monthlyEarningUsdt,
    };
