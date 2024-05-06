// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      blockId: (json['block_id'] as num).toInt(),
      timeStart: json['time_start'] as String,
      timeEnd: json['time_end'] as String,
      blockTime: (json['block_time'] as num).toInt(),
      transactionCount: (json['transaction_count'] as num).toInt(),
      lastBlockHash: json['last_block_hash'] as String,
      targetHash: json['target_hash'] as String,
      solution: json['solution'] as String,
      blockHash: json['block_hash'] as String,
      nextBlockDiff: json['next_block_diff'] as String,
      miner: json['miner'] as String,
      blockFee: (json['block_fee'] as num).toInt(),
      blockReward: (json['block_reward'] as num).toInt(),
      blockDiff: (json['block_diff'] as num).toInt(),
      masternodeCount: (json['masternode_count'] as num).toInt(),
      masternodeReward: (json['masternode_reward'] as num).toInt(),
      masternodeTotalReward: (json['masternode_total_reward'] as num).toInt(),
      circulatingSupply: (json['circulating_supply'] as num).toInt(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'block_id': instance.blockId,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'block_time': instance.blockTime,
      'transaction_count': instance.transactionCount,
      'last_block_hash': instance.lastBlockHash,
      'target_hash': instance.targetHash,
      'solution': instance.solution,
      'block_hash': instance.blockHash,
      'next_block_diff': instance.nextBlockDiff,
      'miner': instance.miner,
      'block_fee': instance.blockFee,
      'block_reward': instance.blockReward,
      'block_diff': instance.blockDiff,
      'masternode_count': instance.masternodeCount,
      'masternode_reward': instance.masternodeReward,
      'masternode_total_reward': instance.masternodeTotalReward,
      'circulating_supply': instance.circulatingSupply,
      'transactions': instance.transactions,
    };
