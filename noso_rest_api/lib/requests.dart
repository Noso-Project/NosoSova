import 'package:noso_rest_api/models/set_price.dart';

import 'models/set_history_transactions.dart';

class NosoApiRequests {
  static String circulatingSupply = "info/circulating_supply";
  static String maxSupply = "info/max_supply";
  static String lockedSupply = "info/locked_supply";
  static String undistributedSupply = "info/undistributed_supply";
  static String nodesInfo = "nodes/info";
  static String health_api = "api/health-check";

  static String price(SetPriceRequest set) {
    return "info/price?range=${set.range}&interval=${set.interval}";
  }

  static String priceExchange(SetPriceRequest set) {
    return "info/price_by_exchange?range=${set.range}&interval=${set.interval}";
  }

  static String nodeStatus(String hash) {
    return "nodes/status?address=$hash";
  }

  static String block(int block) {
    return "blocks/info?block_id=$block";
  }

  static String addressBalance(String hash) {
    return "address/balance?address=$hash";
  }

  static String orderInfo(String txId) {
    return "transactions/order?order_id=$txId";
  }

  static String transactionHistory(SetTransactionsRequest set) {
    return "transactions/history?address=${set.hash}&limit=${set.limit}${set.offset == 0 ? "" : "&offset=${set.offset}"}";
  }
}
