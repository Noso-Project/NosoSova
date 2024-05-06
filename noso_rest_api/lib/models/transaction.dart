import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  int? blockId;
  String orderId;
  String orderType;
  String sender;
  String receiver;
  String amount;
  int? transactionCount;
  String fee;
  String? reference;
  String timestamp;

  Transaction({
    this.blockId,
    required this.orderId,
    required this.orderType,
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.fee,
    this.reference,
    this.transactionCount,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      blockId: json['block_id'] as int?,
      orderId: json['order_id'] as String? ?? '',
      orderType: json['order_type'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      receiver: json['receiver'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      fee: json['fee'] as String? ?? '',
      transactionCount: json['transaction_count'] as int? ?? 1,
      reference: json['reference'] as String?,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
