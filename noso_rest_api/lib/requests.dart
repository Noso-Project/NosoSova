import 'package:noso_rest_api/models/set_price.dart';

import 'models/set_history_transactions.dart';

class NosoApiRequests {
  static String circulatingSupply = "info/circulating_supply";
  static String maxSupply = "info/max_supply";
  static String lockedSupply = "info/locked_supply";
  static String undistributedSupply = "info/undistributed_supply";
  static String nodesInfo = "nodes/info";
  static String price(SetPriceRequest set) {
    return "info/price?range=${set.range}&interval=${set.interval}";
  }

  static String transactionHistory(SetTransactionsRequest set) {
    return "transactions/history?address=${set.hash}&limit=${set.limit}${set.offset == 0 ? "" : "&offset=${set.offset}"}";
  }
}
