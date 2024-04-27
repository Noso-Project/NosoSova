class RPCInfo {
  int supply;
  int walletBalance;

  RPCInfo({this.supply = 0, this.walletBalance = 0});

  RPCInfo copyWith({
    int? supply,
    int? walletBalance,
  }) {
    return RPCInfo(
      supply: supply ?? this.supply,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
