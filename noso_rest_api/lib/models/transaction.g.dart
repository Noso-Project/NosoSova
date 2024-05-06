// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      blockId: (json['blockId'] as num?)?.toInt(),
      orderId: json['orderId'] as String,
      orderType: json['orderType'] as String,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      amount: json['amount'] as String,
      fee: json['fee'] as String,
      reference: json['reference'] as String?,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'blockId': instance.blockId,
      'orderId': instance.orderId,
      'orderType': instance.orderType,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'amount': instance.amount,
      'fee': instance.fee,
      'reference': instance.reference,
      'timestamp': instance.timestamp,
    };
