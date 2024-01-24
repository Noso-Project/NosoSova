import 'package:noso_dart/models/noso/pending.dart';

import '../../models/address_wallet.dart';

class ResponseCalculate {
  List<Address>? address;
  List<Pending>? myPending;
  double totalOutgoing;
  double totalIncoming;
  double totalBalance;
  double allTotalBalance;

  ResponseCalculate({
    this.address,
    this.myPending,
    this.totalOutgoing = 0,
    this.totalIncoming = 0,
    this.totalBalance = 0,
    this.allTotalBalance = 0,
  });

  ResponseCalculate copyWith({
    List<Address>? address,
    List<Pending>? myPending,
    double? totalOutgoing,
    double? totalIncoming,
    double? totalBalance,
    double? allTotalBalance,
  }) {
    return ResponseCalculate(
      address: address ?? this.address,
      myPending: myPending ?? this.myPending,
      totalOutgoing: totalOutgoing ?? this.totalOutgoing,
      totalIncoming: totalIncoming ?? this.totalIncoming,
      totalBalance: totalBalance ?? this.totalBalance,
      allTotalBalance: allTotalBalance ?? this.allTotalBalance,
    );
  }
}
