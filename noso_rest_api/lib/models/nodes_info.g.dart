// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodes_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Masternode _$MasternodeFromJson(Map<String, dynamic> json) => Masternode(
      ipv4: json['ipv4'] as String,
      port: (json['port'] as num).toInt(),
      address: json['address'] as String,
      consecutivePayments: (json['consecutivePayments'] as num).toInt(),
    );

Map<String, dynamic> _$MasternodeToJson(Masternode instance) =>
    <String, dynamic>{
      'ipv4': instance.ipv4,
      'port': instance.port,
      'address': instance.address,
      'consecutivePayments': instance.consecutivePayments,
    };

NodesInfo _$NodesInfoFromJson(Map<String, dynamic> json) => NodesInfo(
      blockId: (json['blockId'] as num).toInt(),
      reward: (json['reward'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      masternodes: (json['masternodes'] as List<dynamic>)
          .map((e) => Masternode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NodesInfoToJson(NodesInfo instance) => <String, dynamic>{
      'blockId': instance.blockId,
      'reward': instance.reward,
      'count': instance.count,
      'masternodes': instance.masternodes,
    };
