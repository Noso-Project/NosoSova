import 'package:json_annotation/json_annotation.dart';
import 'package:noso_rest_api/models/transaction.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  @JsonKey(name: 'block_id')
  final int blockId;
  @JsonKey(name: 'time_start')
  final String timeStart;
  @JsonKey(name: 'time_end')
  final String timeEnd;
  @JsonKey(name: 'block_time')
  final int blockTime;
  @JsonKey(name: 'transaction_count')
  final int transactionCount;
  @JsonKey(name: 'last_block_hash')
  final String lastBlockHash;
  @JsonKey(name: 'target_hash')
  final String targetHash;
  final String solution;
  @JsonKey(name: 'block_hash')
  final String blockHash;
  @JsonKey(name: 'next_block_diff')
  final String nextBlockDiff;
  final String miner;
  @JsonKey(name: 'block_fee')
  final int blockFee;
  @JsonKey(name: 'block_reward')
  final int blockReward;
  @JsonKey(name: 'block_diff')
  final int blockDiff;
  @JsonKey(name: 'masternode_count')
  final int masternodeCount;
  @JsonKey(name: 'masternode_reward')
  final int masternodeReward;
  @JsonKey(name: 'masternode_total_reward')
  final int masternodeTotalReward;
  @JsonKey(name: 'circulating_supply')
  final int circulatingSupply;
  final List<Transaction> transactions;

  Block({
    required this.blockId,
    required this.timeStart,
    required this.timeEnd,
    required this.blockTime,
    required this.transactionCount,
    required this.lastBlockHash,
    required this.targetHash,
    required this.solution,
    required this.blockHash,
    required this.nextBlockDiff,
    required this.miner,
    required this.blockFee,
    required this.blockReward,
    required this.blockDiff,
    required this.masternodeCount,
    required this.masternodeReward,
    required this.masternodeTotalReward,
    required this.circulatingSupply,
    required this.transactions,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
