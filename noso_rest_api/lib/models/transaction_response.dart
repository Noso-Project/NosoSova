import 'package:json_annotation/json_annotation.dart';
import 'package:noso_rest_api/models/transaction.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse {
  List<Transaction> inbound;
  List<Transaction> outbound;

  TransactionResponse({required this.inbound, required this.outbound});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  List<Transaction> getAll() {
    List<Transaction> all = [];
    all.addAll(inbound);
    all.addAll(outbound);

    return all;
  }
}