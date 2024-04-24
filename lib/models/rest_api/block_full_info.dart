class Block {
  final int blockId;
  final String timeStart;
  final String timeEnd;
  final int blockTime;
  final int transactionCount;
  final String lastBlockHash;
  final String targetHash;
  final String solution;
  final String blockHash;
  final String nextBlockDiff;
  final String miner;
  final int blockFee;
  final int blockReward;
  final int blockDiff;
  final int masternodeCount;
  final int masternodeReward;
  final int masternodeTotalReward;
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


  factory Block.fromJson(Map<String, dynamic> json) {
    List<Transaction> transactions = (json['transactions'] as List)
        .map((transactionJson) => Transaction.fromJson(transactionJson))
        .toList();

    return Block(
      blockId: json['block_id'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      blockTime: json['block_time'],
      transactionCount: json['transaction_count'],
      lastBlockHash: json['last_block_hash'],
      targetHash: json['target_hash'],
      solution: json['solution'],
      blockHash: json['block_hash'],
      nextBlockDiff: json['next_block_diff'],
      miner: json['miner'],
      blockFee: json['block_fee'],
      blockReward: json['block_reward'],
      blockDiff: json['block_diff'],
      masternodeCount: json['masternode_count'],
      masternodeReward: json['masternode_reward'],
      masternodeTotalReward: json['masternode_total_reward'],
      circulatingSupply: json['circulating_supply'],
      transactions: transactions,
    );
  }
}


class Transaction {
  final int blockId;
  final String orderId;
  final String timestamp;
  final String orderType;
  final int transactionCount;
  final String sender;
  final String receiver;
  final int totalAmount;
  final int totalFee;
  final String reference;

  Transaction({
    required this.blockId,
    required this.orderId,
    required this.timestamp,
    required this.orderType,
    required this.transactionCount,
    required this.sender,
    required this.receiver,
    required this.totalAmount,
    required this.totalFee,
    required this.reference,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      blockId: json['block_id'],
      orderId: json['order_id'],
      timestamp: json['timestamp'],
      orderType: json['order_type'],
      transactionCount: json['transaction_count'],
      sender: json['sender'],
      receiver: json['receiver'],
      totalAmount: json['total_amount'],
      totalFee: json['total_fee'],
      reference: json['reference'],
    );
  }
}
