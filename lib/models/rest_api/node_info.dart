class NodeInfo {
  final String blockId;
  final String address;
  final String status;
  final String consecutivePayments;
  final String uptimePercent;
  final String monthlyEarning;
  final String monthlyEarningUsdt;

  NodeInfo({
    this.blockId = "",
    this.address = "",
    this.status = "",
    this.consecutivePayments = "",
    this.uptimePercent = "",
    this.monthlyEarning = "",
    this.monthlyEarningUsdt = "",
  });

  factory NodeInfo.fromJson(Map<String, dynamic> json) {
    return NodeInfo(
      blockId: json['block_id'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      consecutivePayments: json['consecutive_payments'] ?? 0,
      uptimePercent: (json['uptime_percent'] ?? 0.0),
      monthlyEarning: (json['monthly_earning'] ?? 0.0),
      monthlyEarningUsdt: (json['monthly_earning_usdt'] ?? 0.0),
    );
  }
}
